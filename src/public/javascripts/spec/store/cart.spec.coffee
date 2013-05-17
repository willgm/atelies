define = require('amdefine')(module, requirejs) if (typeof define isnt 'function')
define [
  'areas/store/models/cart'
], (Cart) ->
  describe 'Cart', ->
    beforeEach ->
      Cart.get().clear()
    afterEach ->
      Cart.get().clear()
    it 'delivers a list of carts when get is run without args', ->
      carts = Cart.get()
      expect(carts.length).to.equal 0
    it 'throws when a cart with empty string is requested', ->
      expect(-> Cart.get('')).to.throw
    it 'delivers the same cart when the store slug is the same', ->
      cart = Cart.get('store_1')
      otherCart = Cart.get('store_1')
      expect(cart).to.equal otherCart
    it 'delivers different carts when the store slug isnt the same', ->
      cart = Cart.get('store_1')
      otherCart = Cart.get('store_2')
      expect(cart).not.to.equal otherCart
    it 'is empty when cleared', ->
      cart = Cart.get('store_1')
      expect(cart.items.length).to.equal 0
    it 'is restored with items from previous session', ->
      cart = Cart.get('store_1')
      item = _id: 1
      cart.addItem item
      Cart._carts = null
      newCart = Cart.get('store_1')
      expect(cart).not.to.equal newCart
      expect(newCart.items()).to.be.like [item]
    it 'is restored with items from previous session and without other cart items', ->
      cart1 = Cart.get('store_1')
      item1 = _id: 1
      cart1.addItem item1
      cart2 = Cart.get('store_2')
      item2 = _id: 2
      cart2.addItem item2
      Cart._carts = null
      newCart1 = Cart.get('store_1')
      expect(newCart1.items()).to.be.like [item1]
      newCart2 = Cart.get('store_2')
      expect(newCart2.items()).to.be.like [item2]
    it 'has items', ->
      cart = Cart.get('store_1')
      item = _id: 1
      cart.addItem item
      expect(cart.items()).to.be.like [item]
    it 'works with a clean localStorage', ->
      localStorage.clear()
      cart = Cart.get('store_1')
      expect(cart.items().length).to.equal 0
    it 'has quantity on the items', ->
      cart = Cart.get('store_1')
      item = _id: 1
      cart.addItem item
      expect(cart.items()[0].quantity).to.equal 1
    it 'when two same products are added it shows correct quantity', ->
      cart = Cart.get('store_1')
      item = _id: 1
      cart.addItem item
      cart.addItem item
      expect(cart.items()[0].quantity).to.equal 2
    it 'when two different products are added it shows correct quantity', ->
      cart = Cart.get('store_1')
      item = _id: 1
      cart.addItem item
      item2 = _id: 2
      cart.addItem item2
      items = cart.items()
      expect(items.length).to.equal 2
      expect(items[0].quantity).to.equal 1
      expect(items[1].quantity).to.equal 1
    it 'when removing an item from cart it is removed and does not come back', ->
      cart = Cart.get('store_5')
      item = _id: 1
      cart.addItem item
      item2 = _id: 2
      cart.addItem item2
      cart.removeById 1
      items = cart.items()
      expect(items.length).to.equal 1
      expect(items[0].quantity).to.equal 1
      expect(items[0]._id).to.equal 2
      expect(Cart.get('store_5').items().length).to.equal 1
