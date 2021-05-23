import ApplicationController from './application_controller'
import { useIntersection } from 'stimulus-use'

export default class extends ApplicationController {
  connect () {
    super.connect()
    useIntersection(this)
  }

  appear () {
    this.stimulate('Stonknotes#load').then(({ payload }) =>
      this.element.setAttribute('data-cursor', payload)
    )
  }
}
