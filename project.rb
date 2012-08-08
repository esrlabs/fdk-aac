cxx_configuration do
  sources = Dir.glob('lib*/**/*.cpp').delete_if do |i|
    i.index('src/mips') ||
    i.index('_linux') ||
    i.index('src/arm')
  end

  includes = Dir.glob('lib*/**/include')

  source_lib 'fdk-aac',
    :sources => sources,
    :includes => includes
end
