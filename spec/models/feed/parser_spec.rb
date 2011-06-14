require 'spec_helper'

#
# Define valid feed entries here
#
module RSpec::Matchers

  def be_valid_entries
    Matcher.new :be_valid_entries do
      match do |entries|

        entries.present? && entries.all? do |entry|

          [:title, :link, :description, :entry_id].all? do |name|

            entry.attributes[name].is_a?(String) &&
              entry.attributes[name].present?

          end &&

          entry.attributes[:date].is_a?(Time) &&

          entry.respond_to?(:save!)

        end

      end # match
    end # Matcher.new
  end # def be_valid_entries

end # module

describe Feed::Parser do

  let(:rss)  { fixture('feed.rss.xml') }
  let(:atom) { fixture('feed.atom.xml') }

  subject { Feed.make_unsaved }

  describe '#xml' do

    it 'should call parse if @xml is not set' do

      subject.should_receive(:parse)
      subject.xml.should be_nil

    end

  end

  describe 'parsing' do

    context 'RSS feed' do

      before        { subject.should_receive(:open).and_return(rss) }
      its(:xml)     { should be_an_instance_of(RSS::Rss) }
      its(:entries) { should be_valid_entries }

    end

    context 'Atom feed' do

      before        { subject.should_receive(:open).and_return(atom) }
      its(:xml)     { should be_an_instance_of(RSS::Atom::Feed) }
      its(:entries) { should be_valid_entries }

    end

    context 'HTTP Error' do

      before        { subject.should_receive(:open).at_least(:once).and_raise("HTTP Error") }
      its(:xml)     { should be_nil }
      its(:entries) { should be_empty }

    end

  end

end
