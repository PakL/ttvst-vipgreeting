<vip>
	<table>
		<tbody>
			<tr>
				<td class="username"><input type="text" ref="usernameinput" value={ username } onchange={ change }></td>
				<td class="filename"><input type="text" ref="filenameinput" value={ filename } onchange={ change }></td>
				<td class="search"><button type="button" ref="searchfilebutton" onclick={ filesearch }></button></td>
				<td class="remove"><button type="button" ref="removebutton" onclick={ remove }></button></td>
			</tr>
			<tr>
				<td class="volumelabel" ref="volumelabel"></td>
				<td class="volumeslider" colspan="2"><input type="range" ref="volumeinput" value={ volume } onchange={ change } min="0.0" max="1.0" step="0.01"></td>
				<td class="test"><button type="button" ref="testbutton" onclick={ test }></button></td>
			</tr>
		</tbody>
	</table>

	<style>
		vip > table {
			width: 100%;
		}
		vip > table .username {
			width: 20%;
		}
		vip > table .filename {
			width: 50%;
		}
		vip > table input, vip > table button {
			box-sizing: border-box;
			width: 100%;
		}
	</style>

	<script>
		const {BrowserWindow, dialog} = require('electron').remote
		const self = this

		this.username = this.opts.vip.user
		this.filename = this.opts.vip.file
		this.volume = this.opts.vip.volume

		this.on('mount', () => {
			self.refs.usernameinput.setAttribute('placeholder', self.root.parentNode._tag.vipaddon.i18n.__('User name'))
			self.refs.filenameinput.setAttribute('placeholder', self.root.parentNode._tag.vipaddon.i18n.__('C:\\path\\to\\audio_file.mp3'))
			self.refs.searchfilebutton.innerText = self.root.parentNode._tag.vipaddon.i18n.__('Browse')
			self.refs.removebutton.innerText = self.root.parentNode._tag.vipaddon.i18n.__('Remove')

			self.refs.volumelabel.innerText = self.root.parentNode._tag.vipaddon.i18n.__('Volume')
			self.refs.testbutton.innerText = self.root.parentNode._tag.vipaddon.i18n.__('Test')
		})

		filesearch() {
			let files = dialog.showOpenDialog(BrowserWindow.getFocusedWindow(), {
				title: self.root.parentNode._tag.vipaddon.i18n.__('Select an audio file'),
				filters: [{name: 'Audio file', extensions: ['wav', 'mp3', 'ogg', 'm4a']}],
				properties: [ 'openFile' ]
			})
			if(files != null && files.hasOwnProperty('length') && files.length > 0) {
				self.filename = files[0]
				self.refs.filenameinput.value = files[0]
			}
			
			self.change()
		}
		change() {
			self.root.parentNode._tag.savevips()
		}
		remove() {
			let table = self.root.querySelector('table')
			table.parentNode.removeChild(table)
			self.root.parentNode._tag.savevips()
		}
		test() {
			if(!self.root.parentNode._tag.vipaddon.playing) {
				self.root.parentNode._tag.vipaddon.play(self.refs.filenameinput.value, self.refs.volumeinput.value)
			}
		}
	</script>
</vip>