def fixture(file)
  File.read( File.join File.dirname(__FILE__), '../fixtures/', file )
end
