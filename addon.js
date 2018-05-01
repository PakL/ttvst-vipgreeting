class VIPGreeting {

	constructor(tool, i18n) {
		const self = this
		this._tool = tool
		this.i18n = i18n
		this.vipsettingsElement = null
		this.vipsettings = []
		this.greetedVIP = []

		this.soundQueue = []
		this.playing = false
		this.playingElement = null

		this._tool.on('load', () => {
			self.settings.appendSetting('', self.i18n.__('Add VIP'), 'button', { set: 'vipgreeting', setLabel: self.i18n.__('VIP Greeting'), onclick: () => {
				if(self.vipsettingsElement !== null && self.vipsettingsElement.hasOwnProperty('_tag')) {
					self.vipsettingsElement._tag.addavip()
				}
			} })
			self.settings.appendSetting('', self.i18n.__('Stop playback') + ' (' + self.i18n.__('{{count}} in queue', {count: 0}) + ')', 'button', {attrid:'vip_stop_playback_button', set: 'vipgreeting', onclick: () => {
				self.stop()
			} })
			self.settings.appendSetting('vipsoundonlyonmychannel', self.i18n.__('Play only if in my channel'), 'checkbox', {default: true, set:'vipgreeting'})
			self.settings.appendSetting('', '', 'separator', {set: 'vipgreeting'})

			riot.compile('/' + __dirname.replace(/\\/g, '/') + '/res/vip.tag', () => {
				riot.compile('/' + __dirname.replace(/\\/g, '/') + '/res/vipsettings.tag', () => {
					self.vipsettingsElement = document.createElement('vipsettings')
					document.querySelector('#settings_set_vipgreeting > fieldset').appendChild(self.vipsettingsElement)
					riot.mount(self.vipsettingsElement, {addon: self})
				})
			})
		})

		this.channel.on('channelonline', () => {
			self.greetedVIP = []
		})
		this.chat.on('chatmessage', (channel, timestamp, userobj, msg, org_msg, type) => {
			if(userobj.user.length <= 0) return
			if(!self.settings.getBoolean('vipsoundonlyonmychannel', true) || channel.toLowerCase() != self._tool.auth.username.toLowerCase()) {
				return
			}
			self.vipsettings.forEach((vip) => {
				if(vip.user.length <= 0) return
				if(vip.user.toLowerCase() == userobj.user.toLowerCase() && self.greetedVIP.indexOf(userobj.user.toLowerCase()) < 0) {
					self.greetedVIP.push(userobj.user.toLowerCase())
					self.play(vip.file, vip.volume)
				}
			})
		})
	}

	play(file, vol) {
		if(typeof(file) === 'string' && file.length > 0) {
			this.soundQueue.push([file, vol])
			document.querySelector('#vip_stop_playback_button').innerText = this.i18n.__('Stop playback') + ' (' + this.i18n.__('{{count}} in queue', {count: this.soundQueue.length}) + ')'
		}

		if(this.playing) return
		const self = this

		if(this.soundQueue.length > 0) {
			this.playing = true
			let sound = this.soundQueue.shift()
			document.querySelector('#vip_stop_playback_button').innerText = this.i18n.__('Stop playback') + ' (' + this.i18n.__('{{count}} in queue', {count: this.soundQueue.length}) + ')'

			let audio = document.createElement('audio')
			audio.setAttribute('src', sound[0])
			audio.volume = sound[1]
			audio.style.display = 'none'

			document.querySelector('body').appendChild(audio)
			audio.onended = () => {
				this.playing = false
				audio.parentNode.removeChild(audio)
				self.play()
			}
			this.playingElement = audio
			audio.play()
		}
	}

	stop() {
		if(this.playing && this.playingElement !== null) {
			this.playingElement.pause()
			this.playing = false
			this.playingElement.parentNode.removeChild(this.playingElement)

			this.play()
		}
	}

	get chat() {
		return this._tool.chat
	}

	get channel() {
		return this._tool.channel
	}

	get settings() {
		return this._tool.settings
	}
}
module.exports = VIPGreeting