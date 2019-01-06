module NSWTopo
  module Formats
    module Mbtiles
      RESOLUTION, ORIGIN, TILE_SIZE = 2 * 78271.516, -20037508.34, 256
    end

    def render_mbtiles(temp_dir, mbtiles_path, name:, zoom: DEFAULT_ZOOM, **options)
      raise "invalid zoom outside 10-19 range: #{zoom}" unless (10..19) === zoom

      web_mercator_bounds = bounds(projection: Projection.new("EPSG:3857"))
      wgs84_bounds = bounds(projection: Projection.wgs84)
      sql = <<~EOF
        CREATE TABLE metadata (name TEXT, value TEXT);
        INSERT INTO metadata VALUES ("name", "#{name}");
        INSERT INTO metadata VALUES ("type", "baselayer");
        INSERT INTO metadata VALUES ("version", "1.1");
        INSERT INTO metadata VALUES ("description", "#{name}");
        INSERT INTO metadata VALUES ("format", "png");
        INSERT INTO metadata VALUES ("bounds", "#{wgs84_bounds.transpose.flatten.join ?,}");
        CREATE TABLE tiles (zoom_level INTEGER, tile_column INTEGER, tile_row INTEGER, tile_data BLOB);
      EOF
      png_path = nil
      zoom.downto(0).inject([]) do |levels, zoom|
        resolution = Mbtiles::RESOLUTION / (2 ** zoom)
        indices, dimensions, topleft = web_mercator_bounds.map do |lower, upper|
          ((lower - Mbtiles::ORIGIN) / resolution / Mbtiles::TILE_SIZE).floor ... ((upper - Mbtiles::ORIGIN) / resolution / Mbtiles::TILE_SIZE).ceil
        end.map.with_index do |indices, axis|
          [ indices, (indices.last - indices.first) * Mbtiles::TILE_SIZE, Mbtiles::ORIGIN + (axis.zero? ? indices.first : indices.last) * Mbtiles::TILE_SIZE * resolution]
        end.transpose
        tile_path = temp_dir.join("#{name}.mbtiles.#{zoom}.%09d.png").to_s
        levels << [ resolution, indices, dimensions, topleft, tile_path, zoom ]
        break levels if indices.map(&:count).all? { |count| count < 3 }
        levels
      end.tap do |(resolution, *, zoom), *|
        png_path = yield(resolution: resolution)
      end.tap do |levels|
        puts "tiling for zoom levels %s" % levels.map(&:last).minmax.uniq.join(?-)
      end.each.in_parallel do |resolution, indices, dimensions, topleft, tile_path, zoom|
        tif_path, tfw_path = %w[tif tfw].map { |ext| temp_dir / "#{name}.mbtiles.#{zoom}.#{ext}" }
        WorldFile.write topleft, resolution, 0, tfw_path
        OS.convert "-size", dimensions.join(?x), "canvas:none", "-type", "TrueColorAlpha", "-depth", 8, tif_path
        OS.gdalwarp "-s_srs", @projection, "-t_srs", "EPSG:3857", "-r", "lanczos", "-dstalpha", png_path, tif_path
        OS.convert tif_path, "-quiet", "+repage", "-crop", "#{Mbtiles::TILE_SIZE}x#{Mbtiles::TILE_SIZE}", tile_path
      end.map do |resolution, indices, dimensions, topleft, tile_path, zoom|
        indices[1].to_a.reverse.product(indices[0].to_a).map.with_index do |(row, col), index|
          [ tile_path % index, zoom, col, row ]
        end
      end.flatten(1).each do |tile_path, zoom, col, row|
        sql << %Q[INSERT INTO tiles VALUES (#{zoom}, #{col}, #{row}, readfile("#{tile_path}"));\n]
      end.tap do |tiles|
        puts "optimising #{tiles.length} tiles"
      end.map(&:first).each.in_parallel_groups do |png_paths|
        dither *png_paths
      end
      OS.sqlite3 mbtiles_path do |stdin|
        stdin.puts sql
        stdin.puts ".exit"
      end
    end
  end
end
