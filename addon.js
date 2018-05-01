const play = require('play')

class VIPGreeting {

	constructor(tool, i18n) {
		const self = this
		this._tool = tool
		this.i18n = i18n
		this.vipsettingsElement = null
		this.vipsettings = []

		this._tool.on('load', () => {
			self.settings.appendSetting('', self.i18n.__('Add VIP'), 'button', { set: 'vipgreeting', setLabel: self.i18n.__('VIP Greeting'), onclick: () => {
				//let greetingSet = document.querySelector('#settings_set_vipgreeting > fieldset')

				if(self.vipsettingsElement !== null && self.vipsettingsElement.hasOwnProperty('_tag')) {
					self.vipsettingsElement._tag.addavip()
				}

				/*let 

				greetingSet.appendChild()*/
			} })
			self.settings.appendSetting('', '', 'separator', {set: 'vipgreeting'})

			riot.compile('/' + __dirname.replace(/\\/g, '/') + '/res/vip.tag', () => {
				riot.compile('/' + __dirname.replace(/\\/g, '/') + '/res/vipsettings.tag', () => {
					self.vipsettingsElement = document.createElement('vipsettings')
					document.querySelector('#settings_set_vipgreeting > fieldset').appendChild(self.vipsettingsElement)
					riot.mount(self.vipsettingsElement, {addon: self})
				})
			})
		})

		this.chat.on('chatmessage', (channel, timestamp, userobj, msg, org_msg, type) => {

			if(channel.toLowerCase() == self._tool.auth.username.toLowerCase()) {
				
			}
		})
	}

	get chat() {
		return this._tool.chat
	}

	get settings() {
		return this._tool.settings
	}
}
module.exports = VIPGreeting