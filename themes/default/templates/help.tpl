<script type="text/x-template" id="help">
  <v-container style="max-width: 1024px;height:100%;padding-top: 32px">
    <v-tabs v-model="tab">
        <v-tab>%feedback%</v-tab>
        <v-tab>%about%</v-tab>
    </v-tabs>
    <div v-show="tab==0" style="height: calc(100% - 106px);overflow-y:auto;">
      <div class="py-6"> 
        <v-alert v-model="success" type="success" dismissible>
         %feedbackok%</v-alert>
        <v-alert v-model="iserror" type="error" dismissible>
         {{error}}</v-alert>
         
       <v-btn color="blue-grey" dark :outlined="like!=1" @click="like=(like==1 ? 0 : 1)" 
          style="text-transform:none;"><v-icon small>fa-thumbs-up</v-icon>&nbsp;%like%</v-btn>
       <v-btn color="blue-grey" dark :outlined="like!=-1" @click="like=(like==-1 ? 0 : -1)"
          style="text-transform:none;"><v-icon small>fa-thumbs-down</v-icon>&nbsp;%dislike%</v-btn>
       <v-textarea class="mt-2" v-model="feedback" auto-grow label="%feedbacktext%"></v-textarea>
       <v-text-field v-model="email" style="max-width: 250px;" label="Email (%optional%)"></v-text-field>
       <v-btn color="primary" @click="sendfeedback">%send%</v-btn>
          <h3 class="py-2 mt-6">%support%</h3>
          <p><a href="mailto:[[.App.Email]]?Subject=Eonza">Email</a><br>
          <a href="[[.App.Issue]]" target="_blank">%repissue%</a><p>

      </div>
    </div>
    <div v-show="tab==1" style="height: calc(100% - 106px);overflow-y:auto;" >
          <h2 class="my-4">[[.App.Title]]</h2>
          <h3>%annotation%</h3>
          <p>%version%: <b>[[.Version]]</b> <small style="color: #777;">[[.CompileDate]]</small>
          <div v-if="upd.notify" v-html="upd.notify"></div>
          <div v-if="!upd.notify && upd.lastchecked">%uptodate%</div>
          <div v-if="upd.lastchecked">%lastcheck% <i>{{upd.lastchecked}}</i></div>
          [[if eq .User.RoleID 1]]<v-btn color="primary" style="text-transform:none;" @click="checkUpdate()"  class="ma-1">
            %checkupdate%
          </v-btn>[[end]]
          </p>
          <p>Copyright [[.App.Copyright]]<br>
          
          <strong><a class="py-3" href="%licenseurl%" target="_blank">%licagreement%</a></strong>
</p>
          <h3 class="py-2">%officialsite%</h3>
          <p><strong><a href="[[.App.Homepage]]" target="_blank">[[.App.Homepage]]</a></strong></p>
    </div>
  </v-container>
</script>

<script>

const Help = {
    template: '#help',
    data: helpData,
    methods: {
      sendfeedback() {
        if (this.like != 0 || this.feedback) {
            axios
            .post(`/api/feedback`, {like: this.like, feedback: this.feedback, email: this.email})
            .then(response => {
                if (response.data.error) {
                    this.iserror = true
                    this.error = response.data.error
                    return
                }
                this.success = true
                this.like = 0
                this.feedback = ''
            })
            .catch(error => {
              this.iserror = true
              this.error = error
            });
        }
      },
      checkUpdate(iscache) {
           axios
            .get('/api/latest' + (!!iscache ? '?cache=true' : '' ))
            .then(response => {
                if (response.data.error) {
                    this.$root.errmsg(response.data.error);
                    return
                }
                this.upd = response.data
            })
            .catch(error => this.$root.errmsg(error));
      },
    },
    mounted: function() {
        store.commit('updateTitle', '%help%');
        store.commit('updateHelp', '%urlhelp%');
        this.checkUpdate(true)
    },
};

function helpData() {
    return {
      like: 0,
      success: false,
      iserror: false,
      error: '',
      feedback: '',
      email: '',
      upd: {
        version: '',
        notify:  '',
        lastchecked: '',
      },
      tab: null
    }
}

</script>