// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dialer/permissions.dart';
import 'package:dialer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import 'package:dialer/phone_number.dart';

/// DialerData is a stateful widget. It holds the phone number
/// and preserves the model state between hot reloads
class DialerData extends StatefulWidget {
  DialerData({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  createState() => _DialerDataState();
}

class _DialerDataState extends State<DialerData> {
  final providers = Providers()
    ..provide(Provider.value(
      PhoneNumber(),
    ));

  @override
  Widget build(BuildContext context) {
    return ProviderNode(
      providers: providers,
      child: widget.child,
    );
  }
}

/// Dialer UI
class Dialer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NumberReadout(),
        NumberPad(),
        SizedBox(height: 50),
        DialButton(),
        SizedBox(height: 50),
      ],
    );
  }
}

/// Decorated dialer UI
class DecoratedDialer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: <Color>[Colors.cyan, Colors.white],
            )),
            child: Opacity(
              opacity: 0.2,
              child: FlutterLogo(),
            ),
          ),
        ),
        Dialer(),
      ],
    );
  }
}

/// Phone number pad
class NumberPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Table(
        children: <TableRow>[
          TableRow(
            children: ['1', '2', '3']
                .map<Widget>((char) => DigitButton(char))
                .toList(),
          ),
          TableRow(
            children: ['4', '5', '6']
                .map<Widget>((char) => DigitButton(char))
                .toList(),
          ),
          TableRow(
            children: ['7', '8', '9']
                .map<Widget>((char) => DigitButton(char))
                .toList(),
          ),
          TableRow(
            children: ['*', '0', '#']
                .map<Widget>((char) => DigitButton(char))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Dialer button
class DigitButton extends StatelessWidget {
  DigitButton(this.char);
  final String char;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Provide.value<PhoneNumber>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 6,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Text(char),
        onPressed: () => phoneNumber.addDigit(char),
      ),
    );
  }
}

/// Another dialer button
class FlatDigitButton extends StatelessWidget {
  FlatDigitButton(this.char);
  final String char;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Provide.value<PhoneNumber>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FlatButton(
        textColor: darkBlue,
        child: Text(char),
        onPressed: () => phoneNumber.addDigit(char),
      ),
    );
  }
}

/// Dials the entered phone number
class DialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<PhoneNumber>(
      builder: (context, _, number) => FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () =>
                number.hasNumber ? dialNumber(number.number, context) : null,
          ),
    );
  }
}

/// Phone number display
class PhoneNumberDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Provide<PhoneNumber>(
        builder: (context, _, phoneNumber) {
          return Text(
            phoneNumber.formattedNumber,
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}

/// Delete button for phone number
class DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.backspace),
      onPressed: () => Provide.value<PhoneNumber>(context).removeDigit(),
    );
  }
}

/// Displays the entered phone number
class NumberReadout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // border: BorderDirectional(bottom: BorderSide(color: darkBlue)),
        border: Border.all(color: darkBlue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          PhoneNumberDisplay(),
          DeleteButton(),
        ],
      ),
    );
  }
}
