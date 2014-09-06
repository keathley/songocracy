module Player
  class LogFormatter < Logger::Formatter
    def call(severity, datetime, progname, msg)
      "\n[#{severity} @ #{datetime.strftime("%H:%M:%S")}]#{clean_progname(progname)}#{msg}"
    end

    private

    def clean_progname(progname)
      progname ? " (#{progname}) " : " "
    end
  end
end
