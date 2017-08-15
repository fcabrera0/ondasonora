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
            var matchName = p.name.toLowerCase().includes(this.filter.q.toLowerCase())
            var matchDescr = p.descr.toLowerCase().includes(this.filter.q.toLowerCase())
            return (matchName || matchDescr) && matchCat
        })
      }
    }
})