nodemailer = require 'nodemailer'
module.exports = class Postman
  @configure = (id, secret) ->
    unless @dryrun
      @smtp = nodemailer.createTransport "SES",
        AWSAccessKeyID: id
        AWSSecretKey: secret
      @running = true
  @stop = -> @smtp.close() if @running

  @classProperty 'dryrun',
    get: =>
      @_dryrun = off unless @_dryrun?
      @_dryrun
    set: (val) =>
      @_dryrun = val
      if val
        @sentMails = []

  send: (from, to, subject, body, cb = (->)) ->
    mail =
      from: "#{from.name} <contato@atelies.com.br>"
      to: "#{to.name} <#{to.email}>"
      subject: subject
      html: body
      generateTextFromHTML: true
      forceEmbeddedImages: true
    if from.email isnt 'contato@atelies.com.br'
      mail.replyTo = "#{from.name} <#{from.email}>"
    if Postman.dryrun
      console.log "NOT sending mail to #{mail.to} with subject #{mail.subject}, dry run"
      Postman.sentMails.push mail
      cb()
    else
      #console.log "Sending mail from #{mail.from} to #{mail.to} with subject '#{mail.subject}'"
      Postman.smtp.sendMail mail, cb

  sendFromContact: @::send.partial {name:'Ateliês', email:'contato@atelies.com.br'}
