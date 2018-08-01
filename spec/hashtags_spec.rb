# frozen_string_literal: true

RSpec.describe Jekyll::Hashtags do

  let(:config_overrides) { {} }

  let(:configs) do
    Jekyll.configuration(config_overrides.merge({
                           "skip_config_files" => false,
                           "collections"       => { "docs" => { "output" => true } },
                           "source"            => blog_dir,
                           "destination"       => blog_dir("_site"),
                        }))
  end

  let(:hashtags) { described_class }
  let(:site) { Jekyll::Site.new(configs) }
  let(:posts)        { site.posts.docs.sort.reverse }
  let(:happy_case)   { find_by_title(posts, "happy case") }
  let(:edge_case_code_block)   { find_by_title(posts, "edge case code block") }
  let(:happy_case_with_config) { find_by_title(posts, "happy case with config")}

  let(:expected_for_code_block)  { "#TradeWar test under code block" }
  let(:expected)      { "test <a href=\"/tags/TradeWar\" target=\"_blank\" class=\"hashtag\">#TradeWar</a> test" }
  let(:expected_with_config)      { "test <a href=\"http://hengwei.me/tags/TradeWar\" target=\"_blank\" class=\"hashtag\">#TradeWar</a> test" }

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  def paragraph(content)
    "<p>#{content}</p>"
  end

  it "has a version number" do
    expect(JekyllHashtags::VERSION).not_to be nil
  end

  it "creates a html pipeline filter" do
    expect(hashtags.filter_with_hashtag).to be_a(HTML::Pipeline)
  end

  it "[happy case] replaces the hashtag in posts correctly" do
    expect(happy_case.output).to match(paragraph(expected))
  end

  it "[code block] do not replace the hashtag in code block correctly" do
    expect(edge_case_code_block.output).to match(expected_for_code_block)
  end

  context "with jekyll configuration override" do
    let(:base_url) {"http://hengwei.me"}
    let(:tag_url) {"/blog/tags/%{tag}"}
    let(:tag_pattern) {'/#([\p{L}\w\-]+)/'}
    let(:config_overrides) do
      {
          "jekyll-hashtags"   => {
              "base_url" => base_url,
              "tag_url"  => tag_url,
              "tag_pattern" => tag_pattern,
          },
      }
    end

    it "fetches the custom base url from the config" do
      expect(hashtags.get_base_url(site.config)).to eql(base_url)
    end

    it "fetches the custom tag url from the config" do
      expect(hashtags.get_tag_url(site.config)).to eql(tag_url)
    end

    it "fetches the custom tag pattern from the config" do
      expect(hashtags.get_hashtag_pattern(site.config)).to eql(tag_pattern)
    end
  end

end
