require 'yaml'
require 'date'

ebook_config_file = 'config-ebook.yml'
config = YAML.load_file(ebook_config_file, permitted_classes: [Date])
book = config['bookname'] || ENV['REVIEW_BOOK'] || 'book'
book_pdf = book + '.pdf'
catalog_file = config['catalogfile'] || ENV['REVIEW_CATALOG_FILE'] || 'catalog.yml'

pdf_options = ENV['REVIEW_PDF_OPTIONS'] || ''

desc 'generate PDF file'
task ebook: book_pdf

images = FileList['images/**/*']
others = ENV['REVIEW_DEPS'] || []
src = FileList['./**/*.re', '*.rb'] + [ebook_config_file, catalog_file] + images + FileList[others]
src_pdf = FileList['layouts/*.erb', 'sty/**/*.sty']

file book_pdf => src + src_pdf do
  FileUtils.rm_rf([book_pdf, book, book + '-pdf'])
  sh "review-pdfmaker #{pdf_options} #{ebook_config_file}"
end
