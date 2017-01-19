require "chefspec"
require "chefspec/berkshelf"

describe "webserver::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it "creates a webserver sites-available" do
    expect(chef_run).to create_template("/etc/nginx/sites-available/webserver").with(
      owner: "root",
      group: "root"
    )
  end
  it "creates the webserver index.html" do
    expect(chef_run).to create_cookbook_file("/var/www/index.html").with(
      owner: "www-data",
      group: "www-data"
    )
  end
end
