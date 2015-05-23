module ApplicationHelper
  include BootstrapHelper

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true, autolink: true)
  end
end
