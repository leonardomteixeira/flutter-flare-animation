import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

enum AnimationToPlay {
  Activate,
  Deactivate,
  CameraTapped,
  PulseTapped,
  ImageTapped
}

class SmartFlareAnimation extends StatefulWidget {
  @override
  _SmartFlareAnimationState createState() => _SmartFlareAnimationState();
}

class _SmartFlareAnimationState extends State<SmartFlareAnimation> {
  final FlareControls animationControls = FlareControls();

  AnimationToPlay _animationToPlay = AnimationToPlay.Deactivate;
  AnimationToPlay _lastPlayedAnimation;

  static const double AnimationWidth = 295.0;
  static const double AnimationHeight = 251.0;
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AnimationWidth,
      height: AnimationHeight,
      child: GestureDetector(
        onTapUp: (tapInfo) {
          setState(() {
            var localTouchPosition = (context.findRenderObject() as RenderBox)
                .globalToLocal(tapInfo.globalPosition);

            var topHalfTouched = localTouchPosition.dy < AnimationHeight / 2;

            var leftSideTouched = localTouchPosition.dx < AnimationWidth / 3;

            var rightSideTouched =
                localTouchPosition.dx > (AnimationWidth / 3) * 2;

            var middleSideTouched = !leftSideTouched && !rightSideTouched;

            if (leftSideTouched && topHalfTouched) {
              print("TopLeft");
              _setAnimationToPLay(AnimationToPlay.CameraTapped);
            } else if (middleSideTouched && topHalfTouched) {
              print("TopMiddle");
              _setAnimationToPLay(AnimationToPlay.PulseTapped);
            } else if (rightSideTouched && topHalfTouched) {
              print("TopRight");
              _setAnimationToPLay(AnimationToPlay.ImageTapped);
            } else {
              if (isOpen) {
                print("Bottom Close");
                _setAnimationToPLay(AnimationToPlay.Deactivate);
              } else {
                _setAnimationToPLay(AnimationToPlay.Activate);
              }

              isOpen = !isOpen;
            }
          });
        },
        child: FlareActor(
          'assets/button-animation.flr',
          animation: _getAnimationName(_animationToPlay),
          controller: animationControls,
        ),
      ),
    );
  }

  String _getAnimationName(AnimationToPlay animationToPlay) {
    switch (animationToPlay) {
      case AnimationToPlay.Activate:
        return 'activate';
      case AnimationToPlay.Deactivate:
        return 'deactivate';
      case AnimationToPlay.CameraTapped:
        return 'camera_tapped';
      case AnimationToPlay.PulseTapped:
        return 'pulse_tapped';
      case AnimationToPlay.ImageTapped:
        return 'image_tapped';
      default:
        return 'deactivate';
    }
  }

  void _setAnimationToPLay(AnimationToPlay animation) {
    var isTappedAnimation = _getAnimationName(animation).contains("_tapped");
    if (isTappedAnimation &&
        _lastPlayedAnimation == AnimationToPlay.Deactivate) {
      return;
    }
    animationControls.play(_getAnimationName(animation));
    _lastPlayedAnimation = animation;
  }
}
