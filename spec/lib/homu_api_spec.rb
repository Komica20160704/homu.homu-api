require './spec/spec_helper'
require './lib/homu_api'

describe HomuApi do
  it '.get_page' do
    page = HomuApi.get_page 0
    expect(page).not_to be false
  end
end
