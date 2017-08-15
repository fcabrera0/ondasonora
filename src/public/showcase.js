showcase = new Vue({
    el: '#showcase',
    data: {
        projects: [],
        filter: {
            q: '',
            cat: 'none',
            order: 'pop'
        }
    },
    computed: {
      filtered_projects: function () {
        return this.projects.filter((p) => {
            var matchCat = this.filter.cat === 'none' ? true : p.cat === this.filter.cat
            return p.name.includes(this.filter.q) && matchCat
        })
      }
    }
})