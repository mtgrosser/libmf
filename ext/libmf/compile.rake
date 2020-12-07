require 'tempfile'
require 'pathname'
require 'shellwords'
require 'rbconfig'

def make_unix(srcdir, tmpdir, libdir, build_name, target_name)
  build = tmpdir.join(build_name)
  target = libdir.join(target_name)
  tmpdir.join('Makefile').write(srcdir.join('Makefile').read)
  system(%{make -C #{Shellwords.escape(tmpdir)} lib DFLAG="" OMPFLAG=""})
  raise 'Compilation error!' unless build.exist?
  target.binwrite(build.binread)
  target.chmod(0755)
end

desc 'Compile the libmf library'
task :compile do
  srcdir = Pathname.new(__dir__)
  libdir = srcdir.parent.parent.join('lib', 'libmf')
  
  Dir.mktmpdir do |dir|
    tmpdir = Pathname.new(dir)
    %w[mf.cpp mf.def mf.h].each do |file|
      tmpdir.join(file).write(srcdir.join(file).read)
    end
    if Gem.win_platform?
      raise 'Compilation currently not supported on Windows'
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/i
      make_unix(srcdir, tmpdir, libdir, 'libmf.2.dylib', 'libmf.dylib')
    else
      make_unix(srcdir, tmpdir, libdir, 'libmf.so.2', 'libmf.so')
    end
  end
end
