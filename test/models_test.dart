import 'package:flutter_test/flutter_test.dart';
import 'package:posapp/provider/src.dart';

void main() {
  group('Dish', () {
    test('creates a Dish with name and price', () {
      final dish = Dish('Coffee', 25000);
      expect(dish.dish, 'Coffee');
      expect(dish.price, 25000);
      expect(dish.id, -1);
    });

    test('fromJson creates Dish correctly', () {
      final json = {'ID': 1, 'dish': 'Tea', 'price': 15000.0};
      final dish = Dish.fromJson(json);
      expect(dish.dish, 'Tea');
      expect(dish.price, 15000.0);
      expect(dish.id, 1);
    });

    test('toJson returns correct map', () {
      final dish = Dish('Juice', 30000);
      final json = dish.toJson();
      expect(json['dish'], 'Juice');
      expect(json['price'], 30000);
    });

    test('fromAsset creates Dish with asset path', () {
      final dish = Dish.fromAsset('Rice', 50000, 'assets/rice.png');
      expect(dish.dish, 'Rice');
      expect(dish.price, 50000);
    });
  });

  group('LineItem', () {
    test('starts with 0 quantity', () {
      final item = LineItem(associatedDish: Dish('Burger', 100));
      expect(item.quantity, 0);
      expect(item.isBeingOrdered(), false);
    });

    test('addOne increments quantity', () {
      final item = LineItem(associatedDish: Dish('Burger', 100));
      expect(item.addOne(), 1);
      expect(item.addOne(), 2);
      expect(item.isBeingOrdered(), true);
    });

    test('substractOne decrements quantity', () {
      final item = LineItem(associatedDish: Dish('Burger', 100), quantity: 3);
      expect(item.substractOne(), 2);
      expect(item.substractOne(), 1);
      expect(item.substractOne(), 0);
      expect(item.substractOne(), 0);
    });

    test('toJson returns correct map', () {
      final item = LineItem(associatedDish: Dish('Pizza', 200), quantity: 2);
      final json = item.toJson();
      expect(json['dish'], 'Pizza');
      expect(json['price'], 200);
      expect(json['quantity'], 2);
    });
  });

  group('LineItemList', () {
    test('is empty when created with no args', () {
      final list = LineItemList();
      expect(list.toList(), isEmpty);
    });

    test('adds items', () {
      final list = LineItemList();
      list.add(LineItem(associatedDish: Dish('A', 10)));
      list.add(LineItem(associatedDish: Dish('B', 20)));
      expect(list.length, 2);
    });

    test('copy creates independent clone', () {
      final original = LineItemList([LineItem(associatedDish: Dish('X', 50), quantity: 3)]);
      final copy = LineItemList.copy(original);
      expect(copy.length, 1);
      expect(copy.first.quantity, 3);
    });
  });

  group('Order', () {
    test('create with default values', () {
      final order = Order.create(tableID: 1);
      expect(order.tableID, 1);
      expect(order.status, TableStatus.empty);
      expect(order.isDeleted, false);
      expect(order.totalPrice, 0);
    });

    test('saleAmount returns 0 for deleted orders', () {
      final order = Order.create(tableID: 1, isDeleted: true);
      expect(order.saleAmount(true), 0);
      expect(order.saleAmount(false), 0);
    });

    test('discount rate must be between 0 and 1', () {
      expect(() => Order(tableID: 1, lineItems: LineItemList(), discountRate: 0.0),
          throwsA(isA<AssertionError>()));
      expect(() => Order(tableID: 1, lineItems: LineItemList(), discountRate: 1.5),
          throwsA(isA<AssertionError>()));
    });
  });

  group('Journal', () {
    test('creates with entry and amount', () {
      final j = Journal(entry: 'Test', amount: 100);
      expect(j.entry, 'Test');
      expect(j.amount, 100);
    });

    test('fromJson creates Journal correctly', () {
      final json = {
        'ID': 1,
        'dateTime': '2024-01-01 12:00:00.000',
        'entry': 'Milk purchase',
        'amount': 50000.0,
      };
      final j = Journal.fromJson(json);
      expect(j.entry, 'Milk purchase');
      expect(j.amount, 50000.0);
      expect(j.id, 1);
    });
  });

  group('Config', () {
    test('stores key-value pair', () {
      final c = Config(key: 'theme', value: 'dark');
      expect(c.key, 'theme');
      expect(c.value, 'dark');
    });

    test('round-trip toJson', () {
      final c = Config(key: 'maxTab', value: 3);
      final json = c.toJson();
      final c2 = Config.fromJson(json);
      expect(c2.key, 'maxTab');
      expect(c2.value, 3);
    });
  });

  group('Node', () {
    test('creates with page and defaults', () {
      final n = Node(page: 0, name: 'Table 1');
      expect(n.page, 0);
      expect(n.name, 'Table 1');
      expect(n.x, 0);
      expect(n.y, 0);
      expect(n.id, -1);
    });

    test('fromJson parses correctly', () {
      final json = {'ID': 5, 'x': 100.0, 'y': 200.0, 'name': 'VIP', 'page': 1};
      final n = Node.fromJson(json);
      expect(n.id, 5);
      expect(n.x, 100.0);
      expect(n.y, 200.0);
      expect(n.name, 'VIP');
      expect(n.page, 1);
    });
  });

  group('TableStatus', () {
    test('has three values', () {
      expect(TableStatus.values.length, 3);
      expect(TableStatus.values, contains(TableStatus.empty));
      expect(TableStatus.values, contains(TableStatus.occupied));
      expect(TableStatus.values, contains(TableStatus.incomplete));
    });
  });
}
