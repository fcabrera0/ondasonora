showcase = new Vue({
    el: '#showcase',
    data: {
        projects: [],
        filter: {
            q: '',
            cat: 'none',
            order: 'popularity'
        }
    },
    methods: {
        sort_function: function (a, b) {
            if (this.filter.order === 'popularity') {
                return b.donations - a.donations
            }
            if (this.filter.order === 'creation') {
                return b.creation - a.creation
            }
            if (this.filter.order === 'deadline') {
                return b.deadline - a.deadline
            }
            if (this.filter.order === 'goal') {
                return b.goal - a.goal
            }
            if (this.filter.order === 'percentage') {
                return (b.current / b.goal) - (a.current / b.goal)
            }
            if (this.filter.order === 'current') {
                return b.current - b.goal
            }
            return 0
        }
    },
    computed: {
        filtered_projects: function () {
            var p = this.projects.filter((p) => {
                var matchCat = this.filter.cat === 'none' ? true : p.cat === this.filter.cat
                var matchName = p.name.toLowerCase().includes(this.filter.q.toLowerCase())
                var matchDescr = p.descr.toLowerCase().includes(this.filter.q.toLowerCase())
                return (matchName || matchDescr) && matchCat
            })

            p.sort(this.sort_function)

            return p
        }
    }
})