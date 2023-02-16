const userController = require('../controllers/userController.js');

const router = require('express').Router()

router.post("/", userController.addUsers);
router.get('/', userController.getAllUsers)
router.get('/:id', userController.getUser)
router.put('/:id', userController.updateUsers)

module.exports = router