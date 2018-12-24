module NSWTopo
  class Projection
    def initialize(string_or_path)
      stdout, * = Open3.capture3 "gdalsrsinfo", "-o", "proj4", string_or_path.to_s
      @proj4 = stdout.chomp.strip
    end

    %w[wkt wkt_simple wkt_noct wkt_esri mapinfo xml].each do |format|
      define_method format do
        stdout, * = Open3.capture3 "gdalsrsinfo", "-o", format, @proj4
        stdout.split(/['\r\n]+/).map(&:strip).join("")
      end
    end

    attr_reader :proj4
    alias to_s proj4
    alias to_str proj4

    def ==(other)
      proj4 == other.proj4
    end

    %w[central_meridian scale_factor].each do |parameter|
      define_method parameter do
        /PARAMETER\["#{parameter}",([\d\.]+)\]/.match(wkt) { |match| match[1].to_f }
      end
    end

    def self.utm(zone, south = true)
      new("+proj=utm +zone=#{zone}#{' +south' if south} +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
    end

    def self.wgs84
      new("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
    end

    def self.transverse_mercator(central_meridian, scale_factor)
      new("+proj=tmerc +lat_0=0.0 +lon_0=#{central_meridian} +k=#{scale_factor} +x_0=500000.0 +y_0=10000000.0 +ellps=WGS84 +datum=WGS84 +units=m")
    end

    def self.utm_zones(collection)
      collection.reproject_to_wgs84.map(&:flatten).flatten(1).map do |longitude, latitude|
        (longitude / 6).floor + 31
      end.minmax.yield_self do |min, max|
        min .. max
      end
    end

    def self.utm_hull(zone)
      longitudes = [ 31, 30 ].map { |offset| (zone - offset) * 6.0 }
      latitudes = [ -80.0, 84.0 ]
      longitudes.product(latitudes).values_at(0,2,3,1)
    end

    # def self.in_zone?(zone, coords, projection)
    #   projection.reproject_to_wgs84(coords).one_or_many do |longitude, latitude|
    #     (longitude / 6).floor + 31 == zone
    #   end
    # end
  end
end
