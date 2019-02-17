import React from "react"
import { createMount } from "@material-ui/core/test-utils"
import { expect } from "chai"
import SiteMenu from "../src/components/SiteMenu"

describe("<SiteMenu />", () => {
  let mount

  before(() => {
    mount = createMount();
  })

  after(() => {
    mount.cleanUp();
  });


  it('has classes prop', () => {
    const wrapper = mount(<SiteMenu />)
    const siteMenu = wrapper.find("SiteMenu")
    expect(siteMenu.prop("classes")).to.exist
    console.log(siteMenu.props())
  })

  describe("<Tabs />", () => {
    it("has About tab", () => {
      const wrapper = mount(<SiteMenu />)
      expect(
        wrapper
          .find("Tab")
          .at(0)
          .prop("label")
      ).to.be.eql("About")
    })
    it("has <FeedsListV2>", () => {
      const wrapper = mount(<SiteMenu />)
      expect(wrapper.find("FeedListV2")).to.exist
    })
  })
  describe("notifications link", () => {
    it("has expected text", () => {
      const wrapper = mount(<SiteMenu />)
      expect(wrapper.find("Button").at(0))
        .text()
        .to.be.eql("Get notified when there's whale activity")
    })
  })
})
