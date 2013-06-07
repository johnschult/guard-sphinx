require 'guard'
require 'guard/guard'

module Guard
  class Sphinx < Guard

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      UI.info "Starting Sphinx on port #{port}..."
      %x{#{executable} --config #{config} --pidfile}
      UI.info "Sphinx is running with PID #{pid}"
      Notifier.notify("Sphinx started on port #{port}.", :title => "Sphinx started!", :image => :success, :group => :sphinx)
      $?.success?
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    #
    # @raise [:task_has_failed] when stop has failed
    # @return [Object] the task result
    #
    def stop
     if pid
        UI.info "Sending TERM signal to Sphinx (#{pid})"
        Process.kill("TERM", pid)
        Notifier.notify("We'll leave the light on...", :title => "Sphinx shutting down.", :image => :pending, :group => :sphinx)
        true
      end
    end

    def config
      File.expand_path(options.fetch(:config), Dir.pwd)
    end

    def pidfile_path
      File.expand_path('log/searchd.development.pid', Dir.pwd)
    end

    def pid
      File.exist?(pidfile_path) && File.read(pidfile_path).to_i
    end

    def executable
      options.fetch(:executable) { 'searchd' }
    end

    def port
      options.fetch(:port) { 9312 }
    end

  end
end
