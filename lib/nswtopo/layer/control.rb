module NSWTopo
  module Control
    include Vector
    CREATE = %w[diameter spot]
    DEFAULTS = YAML.load <<~YAML
      stroke: "#880088"
      stroke-width: 0.25
      control:
        symbol:
          circle:
            r: 3.5
            fill: none
      hashhouse:
        symbol:
          path:
            d: M 0.0 -3.5 L -3.0311 1.75 L 3.0311 1.75 Z
            fill: none
      anc:
        symbol:
          path:
            d: M 2.4749 2.4749 L -2.4749 2.4749 L -2.4749 -2.4749 L 2.4749 -2.4749 Z
            fill: none
      waterdrop:
        stroke: blue
        symbol:
          path:
            d:
              M 0 0 m -2.23839,0.2236045 -0.0140224,1.14282 1.170855,0.1191925 0.0,-1.339135 -1.15682,0.077119 z
              M 0 0 m -0.0334642,-1.50878 0.0,0.399455
              M 0 0 m 0.392875,-1.50878 0.0,0.399455
              M 0 0 m -1.081535,0.14161 c 0.0715645,0.0046977 0.1037855,0.084014 0.171773,0.108668 0.0657195,0.0187117 0.1331575,0.0122917 0.199815,0.0070462 0.0223048,-0.0117439 0.1484175,-0.1057945 0.155449,-0.1200465 0.05642,-0.0468965 0.1326955,-0.164045 0.1320095,-0.2305135 l 0.0140224,-0.368095 c 0.0007182,-0.0187908 -0.0764575,-0.0782145 -0.088739,-0.0924945 -0.0149408,-0.0173796 0.0195888,-0.18494 -0.0091672,-0.1817165 -0.0324667,-0.0125272 -0.0486535,0.0015658 -0.096705,-0.0213724 -0.0118384,-0.0358575 -0.0177632,-0.187173 0.0284575,-0.1786295 0.077931,0.0046984 0.1267665,0.0141708 0.2153655,-0.0160496 0.053697,0.0 0.238308,-0.1706145 0.291606,-0.1706145 l 0.471695,0.0023487 c 0.0301501,0.0 0.0879095,0.0795305 0.102431,0.094052 0.0695555,0.0847735 0.162414,0.1043175 0.289261,0.1458485 0.0324464,0.0039144 0.1450015,-0.0158928 0.154847,0.0070476 0.0223104,0.074298 0.0147364,0.14945 0.0087136,0.177863 -0.0080752,0.038129 -0.083699,-0.000548 -0.0877135,0.048776 -0.0032564,0.0400855 -0.0011431,0.111839 -0.0121744,0.161406 -0.066997,0.0689745 -0.1481655,0.112427 -0.1202985,0.140322 l -0.0018398,0.3150455 c 0.0086072,0.071715 0.0308777,0.1518475 0.056938,0.197939 0.0731535,0.1612905 0.224252,0.1650705 0.241605,0.16954 0.0079604,0.0023488 0.6909,0.0903875 1.076215,0.459235 0.0327873,0.031395 0.1048775,0.092197 0.185794,0.340039 0.07819,0.2394875 0.131383,1.0199 0.105168,1.030645 -0.22309,0.0914305 -0.526155,0.1867355 -0.8869,0.0701505 -0.04501,-0.0145628 0.0047684,-0.3084865 -0.0245392,-0.4487 -0.0300531,-0.1437975 0.0009552,-0.423185 -0.31024,-0.47852 -0.1296715,-0.0230188 -0.548975,0.050106 -0.84308,0.112175 -0.140042,0.0295943 -0.329546,0.047992 -0.429415,0.0280287 -0.061726,-0.0123704 -0.440545,-0.094577 -0.5103,-0.112021 -0.046284,-0.0115864 -0.1494535,-0.0175364 -0.305361,0.0310821 -0.115724,0.036092 -0.1778455,0.124271 -0.174342,0.093527 0.0025601,-0.02247 0.0043764,-1.2985 -0.0003008,-1.32188 z
              M 0 0 m 0.177569,-2.2561 c -0.0710255,-0.0007829 -0.184968,0.101906 -0.32207,0.2004835 -0.1808905,0.1120735 -0.396095,0.0329609 -0.57988,-0.02709 -0.1744085,-0.069209 -0.452655,-0.0117432 -0.47628,0.206409 0.0047208,0.1271165 0.051128,0.3250135 0.205618,0.3331475 0.259609,-0.035154 0.526995,-0.150892 0.78848,-0.066234 0.1043945,0.0461125 0.123179,0.1175475 0.131873,0.115857 l 0.51226,0.0 c 0.008694,0.0015658 0.0274792,-0.0697585 0.131873,-0.115857 0.261478,-0.084658 0.52885,0.0310821 0.78848,0.066234 0.1544935,-0.0081424 0.2010995,-0.2060345 0.2058175,-0.3331475 -0.023632,-0.218162 -0.3020745,-0.2756355 -0.47649,-0.206409 -0.1837745,0.0600495 -0.399,0.1391635 -0.57988,0.02709 -0.139573,-0.1003555 -0.255108,-0.204946 -0.325829,-0.2002875 -0.0012762,-8.61e-05 -0.00252,-0.0001801 -0.0039536,-0.0001957 z
              M 0 0 m -0.583765,-0.92848 c 0.827925,0.1289015 1.53314,0.047131 1.53314,0.047131
              M 0 0 m -0.603575,-0.75355 c 0.827925,0.128891 1.552985,0.061929 1.552985,0.061929
            fill: none
    YAML

    def get_features
      points, controls = GPS.load(@path).points, GeoJSON::Collection.new
      [["control",   /^(1?\d\d)W?$/ ],
       ["hashhouse", /^(HH)$/       ],
       ["anc",       /^(ANC)$/      ],
       ["waterdrop", /^1?\d\dW$|^W$/],
      ].each do |type, selector|
        points.each do |point|
          name = point.properties["name"]
          next unless selector === name
          properties = [["categories", [type, *$1]], ["labels", $1]].select(&:last).to_h
          controls.add_point point.coordinates, properties
        end
      end
      controls
    end

    def to_s
      categories = features.map(&:properties).map do |properties|
        properties["categories"]
      end
      counts = %w[control waterdrop hashhouse].map do |category|
        count = categories.count do |categories|
          categories.any? category
        end
        next unless count > 0
        "%i %s%s" % [count, category, count == 1 ? nil : ?s]
      end.compact
      [@name, counts.join(", ")].join(": ")
    end

    # def labels
    #   types_waypoints.reject do |type, waypoints|
    #     type == :water
    #   end.map do |type, waypoints|
    #     waypoints.map do |waypoint, label|
    #       [0, [CONFIG.map.reproject_from_wgs84(waypoint)], label, [type, label]]
    #     end
    #   end.flatten(1)
    # end

    # def initialize(params)
    #   @path = Pathname(params["path"])
    #   @name = name
    #   @params = YAML.load(PARAMS).deep_merge(params)
    #   radius = 0.5 * @params["diameter"]
    #   scaled_params = YAML.load(SCALING_PARAMS.gsub(/\-?\d\.\d+/) { |number| "%.5g" % (number.to_f * radius) })
    #   spot_radius = 0.5 * @params["spot-diameter"] if @params["spot-diameter"]
    #   scaled_params["control"]["symbol"] << { "circle" => { "r" => 0.5 * spot_radius, "stroke-width" => spot_radius, "fill" => "none" } } if spot_radius
    #   @params = scaled_params.deep_merge(@params)
    #   @path = Pathname.new(@params["path"]).expand_path
    # end

    # SCALING_PARAMS = %q[
    #   fence: 2.0
    #   control:
    #     symbol:
    #     - circle:
    #         r: 1.0
    #         fill: none
    #   hashhouse:
    #     symbol:
    #       path:
    #         d: M 0.0 -1.0 L -0.866 0.5 L 0.866 0.5 Z
    #         fill: none
    #   anc:
    #     symbol:
    #       path:
    #         d: M 0.7071 0.7071 L -0.7071 0.7071 L -0.7071 -0.7071 L 0.7071 -0.7071 Z
    #         fill: none
    #   water:
    #     symbol:
    #       path:
    #         d:
    #           M 0 0 m -0.63954,0.063887 -0.0040064,0.32652 0.33453,0.034055 0,-0.38261 -0.33052,0.022034 z
    #           M 0 0 m -0.0095612,-0.43108 0,0.11413
    #           M 0 0 m 0.11225,-0.43108 0,0.11413
    #           M 0 0 m -0.30901,0.04046 c 0.020447,0.0013422 0.029653,0.024004 0.049078,0.031048 0.018777,0.0053462 0.038045,0.0035119 0.05709,0.0020132 0.0063728,-0.0033554 0.042405,-0.030227 0.044414,-0.034299 0.01612,-0.013399 0.037913,-0.04687 0.037717,-0.065861 l 0.0040064,-0.10517 c 0.00020519,-0.0053688 -0.021845,-0.022347 -0.025354,-0.026427 -0.0042688,-0.0049656 0.0055968,-0.05284 -0.0026192,-0.051919 -0.0092762,-0.0035792 -0.013901,0.00044738 -0.02763,-0.0061064 -0.0033824,-0.010245 -0.0050752,-0.053478 0.0081307,-0.051037 0.022266,0.0013424 0.036219,0.0040488 0.061533,-0.0045856 0.015342,0 0.068088,-0.048747 0.083316,-0.048747 l 0.13477,0.00067107 c 0.0086143,0 0.025117,0.022723 0.029266,0.026872 0.019873,0.024221 0.046404,0.029805 0.082646,0.041671 0.0092704,0.0011184 0.041429,-0.0045408 0.044242,0.0020136 0.0063744,0.021228 0.0042104,0.0427 0.0024896,0.050818 -0.0023072,0.010894 -0.023914,-0.00015658 -0.025061,0.013936 -0.0009304,0.011453 -0.00032659,0.031954 -0.0034784,0.046116 -0.019142,0.019707 -0.042333,0.032122 -0.034371,0.040092 l -0.00052567,0.090013 c 0.0024592,0.02049 0.0088222,0.043385 0.016268,0.056554 0.020901,0.046083 0.064072,0.047163 0.06903,0.04844 0.0022744,0.00067108 0.1974,0.025825 0.30749,0.13121 0.0093678,0.00897 0.029965,0.026342 0.053084,0.097154 0.02234,0.068425 0.037538,0.2914 0.030048,0.29447 -0.06374,0.026123 -0.15033,0.053353 -0.2534,0.020043 -0.01286,-0.0041608 0.0013624,-0.088139 -0.0070112,-0.1282 -0.0085866,-0.041085 0.0002729,-0.12091 -0.08864,-0.13672 -0.037049,-0.0065768 -0.15685,0.014316 -0.24088,0.03205 -0.040012,0.0084555 -0.094156,0.013712 -0.12269,0.0080082 -0.017636,-0.0035344 -0.12587,-0.027022 -0.1458,-0.032006 -0.013224,-0.0033104 -0.042701,-0.0050104 -0.087246,0.0088806 -0.033064,0.010312 -0.050813,0.035506 -0.049812,0.026722 0.00073147,-0.00642 0.0012504,-0.371 -8.5944e-05,-0.37768 z
    #           M 0 0 m 0.050734,-0.6446 c -0.020293,-0.00022369 -0.052848,0.029116 -0.09202,0.057281 -0.051683,0.032021 -0.11317,0.0094174 -0.16568,-0.00774 -0.049831,-0.019774 -0.12933,-0.0033552 -0.13608,0.058974 0.0013488,0.036319 0.014608,0.092861 0.058748,0.095185 0.074174,-0.010044 0.15057,-0.043112 0.22528,-0.018924 0.029827,0.013175 0.035194,0.033585 0.037678,0.033102 l 0.14636,0 c 0.002484,0.00044738 0.0078512,-0.019931 0.037678,-0.033102 0.074708,-0.024188 0.1511,0.0088806 0.22528,0.018924 0.044141,-0.0023264 0.057457,-0.058867 0.058805,-0.095185 -0.006752,-0.062332 -0.086307,-0.078753 -0.13614,-0.058974 -0.052507,0.017157 -0.114,0.039761 -0.16568,0.00774 -0.039878,-0.028673 -0.072888,-0.058556 -0.093094,-0.057225 -0.00036462,-2.4608e-05 -0.00072.451,-5.1456e-05 -0.0011296,-5.5928e-05 z
    #           M 0 0 m -0.16679,-0.26528 c 0.23655,0.036829 0.43804,0.013466 0.43804,0.013466
    #           M 0 0 m -0.17245,-0.2153 c 0.23655,0.036826 0.44371,0.017694 0.44371,0.017694
    #         fill: none
    #   labels:
    #     margin: 1.4142
    # ]
  end
end
