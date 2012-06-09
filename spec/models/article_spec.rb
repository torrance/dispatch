require 'spec_helper'

describe Article do
  let(:article) do
    article = Article.new
    article.title = 'I am am article title'
    article.summary = "This is a summary for my article."
    article.body = "This is a body field for my article."
    article.category = "Protest & Revolution"
    article
  end

  specify { article.valid?.should be_true }

  specify { article.save.should be_true }

  context "Invalid category provided" do
    specify do
      article.category = "Fake category"
      article.valid?.should be_false
    end
  end

  context "Invaild summary provided" do
    specify do
      article.summary = "i" * 306
      article.valid?.should be_false
    end
  end

end
