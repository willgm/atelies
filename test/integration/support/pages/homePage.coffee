Page    = require './page'

module.exports = class HomePage extends Page
  url: ''
  clickSearchStores: (cb) => @browser.clickLink ".searchStores", cb
  searchStoresText: (text) -> @browser.fill "#storeSearchTerm", text
  clickDoSearchStores: (cb) => @browser.pressButtonWait "#doSearch", cb
