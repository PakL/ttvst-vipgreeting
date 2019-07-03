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
	<input type="hidden" class="key" ref="key" value={ key }>

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
		export default {
			
			onBeforeMount() {
				this.username = this.props.vip.user
				this.filename = this.props.vip.file
				this.volume = this.props.vip.volume
				this.key = this.props.vip.key
			},

			onMounted() {
				this.refs = {
					usernameinput: this.$('[ref=usernameinput]'),
					filenameinput: this.$('[ref=filenameinput]'),
					searchfilebutton: this.$('[ref=searchfilebutton]'),
					removebutton: this.$('[ref=removebutton]'),
					volumelabel: this.$('[ref=volumelabel]'),
					volumeinput: this.$('[ref=volumeinput]'),
					testbutton: this.$('[ref=testbutton]'),
					key: this.$('[ref=key]')
				}

				this.refs.usernameinput.setAttribute('placeholder', this.root.parentNode._tag.vipaddon.i18n.__('User name'))
				this.refs.filenameinput.setAttribute('placeholder', this.root.parentNode._tag.vipaddon.i18n.__('C:\\path\\to\\audio_file.mp3'))
				this.refs.searchfilebutton.innerText = this.root.parentNode._tag.vipaddon.i18n.__('Browse')
				this.refs.removebutton.innerText = this.root.parentNode._tag.vipaddon.i18n.__('Remove')

				this.refs.volumelabel.innerText = this.root.parentNode._tag.vipaddon.i18n.__('Volume')
				this.refs.testbutton.innerText = this.root.parentNode._tag.vipaddon.i18n.__('Test')
			},

			onBeforeUpdate() {
				this.username = this.props.vip.user
				this.filename = this.props.vip.file
				this.volume = this.props.vip.volume
				this.key = this.props.vip.key
			},

			filesearch() {
				let files = dialog.showOpenDialog(BrowserWindow.getFocusedWindow(), {
					title: this.root.parentNode._tag.vipaddon.i18n.__('Select an audio file'),
					filters: [{name: 'Audio file', extensions: ['wav', 'mp3', 'ogg', 'm4a']}],
					properties: [ 'openFile' ]
				})
				if(files != null && files.hasOwnProperty('length') && files.length > 0) {
					this.filename = files[0]
					this.refs.filenameinput.value = files[0]
				}
				
				this.change()
			},
			change(e) {
				e.preventDefault();
				this.root.parentNode._tag.savevips()
			},
			remove(e) {
				e.preventDefault();
				this.refs.key.value = '-1'
				this.root.parentNode._tag.savevips()
			},
			test() {
				if(!this.root.parentNode._tag.vipaddon.playing) {
					this.root.parentNode._tag.vipaddon.play(this.refs.filenameinput.value, this.refs.volumeinput.value)
				}
			}
		}
	</script>
</vip>