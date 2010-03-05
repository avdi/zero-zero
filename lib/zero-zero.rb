module ZeroZero
  def self.create_problem_report!(error=$!)
    exec = File.basename($0)
    filename = Time.now.utc.strftime("#{exec}-%Y%m%d-%H%M%S-#{$$}.problem")
    problem_info = {}
    problem_info['backtrace'] = error.backtrace
    problem_info['error'] = error
    File.open(filename, 'w') do |file|
      YAML.dump(problem_info, file)
    end
    return filename
  end
end

at_exit do
  if $!.kind_of?(Exception) && (!$!.kind_of?(SystemExit))
    problem_report_file = ZeroZero.create_problem_report!($!)
    $stderr.puts <<END
This program has encountered a problem and cannot continue.
The error was: #{$!.message}
An error report has been created at: #{problem_report_file}
Please email ??? or visit
??? to file a problem ticket.
Please attach the error report file to your email or ticket.
END
  end
end

