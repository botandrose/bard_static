module Bard
  module Static
    class NoRobotsMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        if env["bard_static.prototype"] && status == 200
          no_robots_tag = %{<meta name="robots" content="noindex, nofollow"/>\n}
          response.each do |part|
            part.sub! "</head>", "#{no_robots_tag}</head>"
          end
        end

        [status, headers, response]
      end
    end
  end
end
