define [
  'jquery'
  'backbone'
  'handlebars'
  '../models/productsHome'
  'text!./templates/home.html'
  'caroufredsel'
  'imagesloaded'
], ($, Backbone, Handlebars, ProductsHome, homeTemplate) ->
  class Home extends Backbone.View
    template: homeTemplate
    initialize: (opt) ->
      @products = opt.products
      @stores = opt.stores
    render: ->
      context = Handlebars.compile @template
      @$el.html context stores: @stores, products: @products
      $ ->
        $('#products').imagesLoaded
          always: ->
            $('#carousel').carouFredSel
              scroll:
                items:1
                easing:'linear'
                duration: 1000
              width: '100%'
              auto:
                pauseOnHover: true
              prev:
                button  : "#carouselRight"
                key     : "right"
              next:
                button: "#carouselLeft"
                key: "left"
