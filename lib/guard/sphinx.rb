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
      started = $?.success?
      if started
        UI.info "Sphinx is running with PID #{pid}"
        Notifier.notify("Sphinx started on port #{port}.",
          :title => "Sphinx started!",
          :image => :success,
          :group => :sphinx)
      else
        UI.error "Sphinx did not start!"
        Notifier.notify("Sphinx did not start!",
          :title => "Sphinx problem!",
          :image => :failed,
          :group => :sphinx)
      end
      started
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
        stopped = $?.success?
        if stopped
          UI.info "Sphinx (#{pid}) was stopped."
          Notifier.notify("We'll leave the light on...",
            :title => "Sphinx shutting down.",
            :image => :pending,
            :group => :sphinx)
        else
          UI.error "Sphinx (#{pid}) was not stopped!"
          Notifier.notify("Sphinx was not stopped!",
            :title => "Sphinx problem!",
            :image => :failed,
            :group => :sphinx)
        end
        stopped
      else
        UI.error "Sphinx could not be stopped because there is no PID file!"
        Notifier.notify("Sphinx could not be stopped because there is no PID file!",
          :title => "Sphinx problem!",
          :image => :failed,
          :group => :sphinx)
        false
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
