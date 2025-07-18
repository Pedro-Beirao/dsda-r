require 'test_helper'

class IwadsShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
    @iwad  = iwads(:doom2)
  end

  test "layout and buttons" do
    get iwad_path(@iwad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @iwad.name, response.body
    assert_select "a[href=?]", iwad_stats_path(@iwad)
    @iwad.wads.page(1).each do |wad|
      assert_select "a[href=?]", wad_path(wad)
      assert_select "td", wad.name
      assert_select "td", wad.author
      assert_select "td", wad.demos.count.to_s
      assert_select "td", total_demo_time(wad, false)
    end
  end
end
