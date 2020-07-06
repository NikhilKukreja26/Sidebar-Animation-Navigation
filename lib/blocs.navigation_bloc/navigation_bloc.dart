import 'package:bloc/bloc.dart';

import '../pages/home_page.dart';
import '../pages/my_account_page.dart';
import '../pages/my_order_page.dart';

enum NavigationEvents {
  HomePageClickEvent,
  MyAccountsPageClickEvent,
  MyOrdersPageClickEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountsPageClickEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersPageClickEvent:
        yield MyOrdersPage();
        break;
    }
  }
}
