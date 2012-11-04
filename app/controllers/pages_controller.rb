class PagesController < HighVoltage::PagesController
  before_filter :set_pages_flag

  # We set this flag so that we can modify the standard application layout slightly.
  # It's a bit yucky, I know.
  def set_pages_flag
    @pages_flag = true
  end
end
