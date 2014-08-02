module Tugboat
  module Middleware
    class InjectUI < Base
      def call(env)
        machine = env["machine_readable"] || false
        colors = env["colors"] || true

        ui = Tugboat::UI.new(machine, colors)

        env["ui"] = ui

        @app.call(env)
      end
    end
  end
end

