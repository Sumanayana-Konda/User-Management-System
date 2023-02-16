const productController = require('../controllers/productController.js');

const router = require('express').Router()

router.post("/", productController.addProduct);
router.get('/', productController.getAllProducts);
router.put('/:id', productController.updateProduct);
router.get('/:id', productController.getProduct);
router.delete('/:id', productController.deleteProduct);
router.patch('/:id', productController.patchProduct);

module.exports = router