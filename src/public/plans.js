var app = new Vue({
    el: '#app',
    data: {
        project_id: null,
        plans: [],
        doc: {
            name: '',
            descr: '',
            floor: 0
        }
    },
    methods: {
        add: function () {
            this.plans.push(this.doc)
            this.doc = {
                name: '',
                descr: '',
                floor: 0
            }
        },
        save: function () {
            var e = {
                plans: JSON.stringify(this.plans)
            }
            $.post('/plans/' + this.project_id, e,
                (res) => console.log(res))
        }
    }
})