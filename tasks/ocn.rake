# frozen_string_literal: true

namespace :ocn do
  desc 'Converts all CSVs in the bucket to OCN files'
  task :import do
    OCNImporter.import_all
  end
end
