var app = new Vue({
    el: '#app',
    data: {
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

        }
    }
})