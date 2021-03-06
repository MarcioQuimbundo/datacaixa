
import 'package:datacaixa/helpers/shared_preferences_helper.dart';
import 'package:datacaixa/models/product.dart';
import 'package:datacaixa/models/product_group.dart';
import 'package:datacaixa/repository/repository.dart';

class ProductsRepository extends Repository {
  loadProducts(int group, int page) async {
    initStore();
    List<Product> products = [];
    try {
      String order = await Prefs.getProductsOrder();
      return await productService.getProductsByGroup(group, page, order);
    } catch (_) {
      return store.productDao.getAllByGroup(group);
    }
  }

  loadProductsInOrder(int page) async {
    initStore();
    List<Product> products = [];
    try {
      String order = await Prefs.getProductsOrder();
      products = await productService.getProducts(page, order);
    } catch (_){
      return products;
    }
  }

  loadProductGroups() async {
    initStore();
    List<ProductGroup> groups = [];
    try {
      groups = await productService.getProductGroups();
      await addNoneExisting(store.productGroupDao, groups);
      return groups;
    } catch (_){
      return await store.productGroupDao.getAll();
    }
  }
}