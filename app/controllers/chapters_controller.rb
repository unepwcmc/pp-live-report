class ChaptersController < ApplicationController
  layout 'chapter'

  def chapter_1
    @chapter_number = 1
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-1.yml", 'r'))
  end

  def chapter_2
    @chapter_number = 2
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))
  end

  def chapter_3
    @chapter_number = 3
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))
  end

  def chapter_4
    @chapter_number = 4
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))
  end

  def chapter_5
    @chapter_number = 5
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))
  end

  def chapter_6
    @chapter_number = 6
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))
  end

  def chapter_7
    @chapter_number = 7
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))
  end

  def chapter_8
    @chapter_number = 8
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))
  end

  def chapter_9
    @chapter_number = 9
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))
  end

  def chapter_10
    @chapter_number = 10
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))
  end
end