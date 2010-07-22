require 'tempfile'

module SilencesErrors
  def silence_errors(&block)
    silence_stderr
    block.call
  rescue
    @file.flush if @file
    raise
  ensure
    restore_stderr
  end

  def silence_stderr
    @file     = Tempfile.new('silence_errors')
    @original = STDERR.dup
    STDERR.reopen(@file)
  end

  def restore_stderr
    STDERR.reopen(@original)
  end
end
