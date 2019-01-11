module NSWTopo
  module Feature
    include Vector, ArcGISServer, Shapefile
    CREATE = %w[features]

    # TODO: if @path is set, get features from there instead
    def get_features
      (Array === @features ? @features : [ @features ]).map do |args|
        case args
        when Hash then args.transform_keys(&:to_sym)
        when String then { source: args }
        else raise "#{@source}: invalid or no features specified"
        end
      end.slice_before do |args|
        !args[:fallback]
      end.map do |fallbacks|
        options, collection, error = fallbacks.inject [ {}, nil, nil ] do |(options, *), source: nil, fallback: false, **args|
          warn "\r\e[K#{@name}: failed to retrieve features, trying fallback source" if fallback
          raise "#{@source}: no feature source defined" unless source
          options.merge! args
          break options, arcgis_layer(source, margin: MARGIN, **options.slice(:where, :layer, :per_page)) do |index, total|
            print "\r\e[K#{@name}: retrieved #{index} of #{total} features"
          end if ArcGISServer === source
          source_path = Pathname(source).expand_path(@source.parent)
          break options, shapefile_layer(source_path, margin: MARGIN, **options.slice(:where, :sql, :layer)) if Shapefile === source_path
          raise "#{@source}: invalid feature source: #{source}"
        rescue ArcGISServer::Error => error
          next options, nil, error
        end

        raise error if error
        puts "\r\e[K%s: retrieved %i feature%s" % [ @name, collection.count, (?s unless collection.one?) ]

        next collection.reproject_to(@map.projection), options
      end.each do |collection, options|
        rotation_key = %i[rotation rotation-arithmetic rotation-geographic].find &options.method(:key?)
        rotation_attribute = options[rotation_key] if rotation_key

        collection.each do |feature|
          categories = [ *options[:category] ].map do |category|
            Hash === category ? [ *category ] : [ category ]
          end.flatten(1).map do |attribute, substitutions|
            value = feature.properties.fetch(attribute, attribute)
            substitutions ? substitutions.fetch(value, value) : value
          end

          options[:sizes].tap do |mm, max = 9|
            unit = 0.001 * (mm == true ? 5 : mm) * @map.scale
            case feature
            when GeoJSON::LineString, GeoJSON::MultiLineString
              size = (Math::log2(feature.length) - Math::log2(unit)).ceil rescue 0
              categories << size.clamp(0, max)
            when GeoJSON::Polygon, GeoJSON::MultiPolygon
              size = (0.5 * Math::log2(feature.area) - Math::log2(unit)).ceil rescue 0
              categories << size.clamp(0, max)
            end
          end if options[:sizes]

          rotation = case feature
          when GeoJSON::Point, GeoJSON::MultiPoint
            value = begin
              Float feature.properties.fetch(rotation_attribute)
            rescue KeyError, TypeError, ArgumentError
              0.0
            end
            categories << (value.zero? ? "unrotated" : "rotated")
            case rotation_key.to_s
            when "rotation-arithmetic" then 90 - value
            when "rotation-geographic" then value
            when "rotation"            then value
            end
          end if rotation_attribute

          labels = [ *options[:label] ].map do |attribute|
            feature.properties.fetch(attribute, attribute)
          end.map(&:to_s).reject(&:empty?)

          categories, properties = categories.map(&:to_s).reject(&:empty?).map(&:to_category), {}
          properties["categories"] = categories if categories.any?
          properties["labels"] = labels if labels.any?
          properties["draw"] = false if options[:draw] == false
          properties["draw"] = false if /-labels$/ === @name
          properties["rotation"] = rotation if rotation

          feature.properties.replace properties
        end
      end.map(&:first).inject(&:merge)
    end
  end
end
