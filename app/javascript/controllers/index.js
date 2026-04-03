import { application } from "controllers/application"
import FilterController from "controllers/filter_controller"
import FormController from "controllers/form_controller"
import FlashController from "controllers/flash_controller"

application.register("filter", FilterController)
application.register("form", FormController)
application.register("flash", FlashController)
