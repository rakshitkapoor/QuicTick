import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';

class qr_widget extends StatelessWidget {
  const qr_widget({super.key,required this.qr_key});
  final qr_key;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
                child: CustomPaint(
                  painter: QrPainter(
                    data: qr_key,
                    options:  QrOptions(
                      shapes: QrShapes(
                        darkPixel:
                            QrPixelShapeRoundCorners(cornerFraction: screenSize.height*0.05),
                        frame: QrFrameShapeCircle(),
                        ball: QrBallShapeCircle(),
                      ),
                      colors: QrColors(
                        dark: QrColorLinearGradient(colors: [Colors.blue.shade300,Colors.green.shade300],orientation: GradientOrientation.leftDiagonal),
                        light: QrColorSolid(Colors.transparent),
                        background:QrColorSolid(Colors.transparent) 
                      ),
                    ),
                  ),
                  size: const Size(150, 150),
                ),
              );
  }
}