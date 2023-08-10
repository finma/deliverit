import 'package:deliverit/model/payload.dart';

class DataPayload {
  static final all = <Payload>[
    Payload(name: 'Kardus', size: PayloadSize.small),
    Payload(name: 'Kardus', size: PayloadSize.medium),
    Payload(name: 'Kardus', size: PayloadSize.large),
    Payload(name: 'Kasur', size: PayloadSize.medium),
    Payload(name: 'Kasur', size: PayloadSize.large),
    Payload(name: 'Meja', size: PayloadSize.medium),
    Payload(name: 'Meja', size: PayloadSize.large),
    Payload(name: 'Lemari', size: PayloadSize.medium),
    Payload(name: 'Lemari', size: PayloadSize.large),
    Payload(name: 'Koper', size: PayloadSize.small),
    Payload(name: 'Koper', size: PayloadSize.medium),
    Payload(name: 'Koper', size: PayloadSize.large),
  ];
}
