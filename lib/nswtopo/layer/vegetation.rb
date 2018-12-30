module NSWTopo
  module Vegetation
    include Raster
    CREATE = %w[mapping contrast colour resolution]

    def get_raster(temp_dir)
      txt_path = temp_dir / "source.txt"
      vrt_path = temp_dir / "source.vrt"

      min, max = minmax = @mapping&.values_at("min", "max")
      low, high, factor = { "low" => 0, "high" => 100, "factor" => 0.0 }.merge(@contrast || {}).values_at "low", "high", "factor"
      woody, nonwoody = { "woody" => "#A6F1A6", "non-woody" => "#FFFFFF" }.merge(@colour || {}).values_at("woody", "non-woody").map { |string| Colour.new string }
      # resolution = params["resolution"] if Numeric === params["resolution"]

      colour_table = (0..255).map do |index|
        case
        when minmax&.all?(Integer) && minmax.all?(0..255)
          [ [ 0.0, 100.0 * (index - min) / (max - min) ].max, 100.0 ].min
        when @mapping&.keys&.all?(Integer)
          @mapping.fetch(index, 0)
        else raise "no vegetation colour mapping specified for #{name}"
        end
      end.map do |percent|
        [ [ 0.0, Float(percent - low) / (high - low) ].max, 1.0 ].min
      end.map do |x|
        next x if factor.zero?
        [ x, 1.0 ].map do |x|
            [ x, 0.0 ].map do |x|
                1 / (1 + Math::exp(factor * (0.5 - x)))
            end.inject(&:-)
        end.inject(&:/) # sigmoid between 0..1
      end.map do |x|
        nonwoody.mix(woody, x)
      end

      raise "no vegetation data file specified" if @paths.empty?
      @paths.group_by do |path|
        Projection.new(path)
      end.map.with_index do |(projection, paths), index|
        indexed_tif_path = temp_dir / "indexed.#{index}.tif"
        indexed_vrt_path = temp_dir / "indexed.#{index}.vrt"
        coloured_tif_path = temp_dir / "coloured.#{index}.tif"
        tif_path = temp_dir / "output.#{index}.tif"

        txt_path.write paths.join(?\n)
        OS.gdalbuildvrt "-overwrite", "-input_file_list", txt_path, vrt_path
        OS.gdal_translate "-projwin", *@map.projwin(projection), "-r", "near", "-co", "TFW=YES", vrt_path, indexed_tif_path
        OS.gdal_translate "-of", "VRT", indexed_tif_path, indexed_vrt_path

        xml = REXML::Document.new indexed_vrt_path.read
        raise "can't process vegetation data for #{@name}" unless xml.elements.each("/VRTDataset/VRTRasterBand/ColorTable", &:itself).one?
        raise "can't process vegetation data for #{@name}" unless xml.elements.each("/VRTDataset/VRTRasterBand/ColorTable/Entry", &:itself).count == 256
        xml.elements.collect("/VRTDataset/VRTRasterBand/ColorTable/Entry", &:itself).zip(colour_table) do |entry, colour|
          entry.attributes["c1"], entry.attributes["c2"], entry.attributes["c3"], entry.attributes["c4"] = *colour.triplet, 255
        end
        indexed_vrt_path.write xml
        OS.gdal_translate "-expand", "rgb", indexed_vrt_path, coloured_tif_path

        OS.gdalwarp "-s_srs", projection, "-t_srs", @map.projection, "-r", "bilinear", coloured_tif_path, tif_path
        [ tif_path, @resolution || get_resolution(tif_path) ]
      end.transpose.tap do |tif_paths, resolutions|
        @resolution = resolutions.min
        txt_path.write tif_paths.join(?\n)
        OS.gdalbuildvrt "-overwrite", "-input_file_list", txt_path, vrt_path
      end

      return @resolution, vrt_path
    end
  end
end