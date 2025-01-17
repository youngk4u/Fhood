//
//  LTMorphingLabel.swift
//  https://github.com/lexrus/LTMorphingLabel
//
//  The MIT License (MIT)
//  Copyright (c) 2016 Lex Tang, http://lexrus.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files
//  (the “Software”), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UIKit
import QuartzCore


enum LTMorphingPhases: Int {
    case Start, Appear, Disappear, Draw, Progress, SkipFrames
}


typealias LTMorphingStartClosure =
    () -> Void

typealias LTMorphingEffectClosure =
    (Character, _ index: Int, _ progress: Float) -> LTCharacterLimbo

typealias LTMorphingDrawingClosure =
    (LTCharacterLimbo) -> Bool

typealias LTMorphingManipulateProgressClosure =
    (_ index: Int, _ progress: Float, _ isNewChar: Bool) -> Float

typealias LTMorphingSkipFramesClosure =
    () -> Void


@objc public protocol LTMorphingLabelDelegate {
    @objc optional func morphingDidStart(label: LTMorphingLabel)
    @objc optional func morphingDidComplete(label: LTMorphingLabel)
    @objc optional func morphingOnProgress(label: LTMorphingLabel, progress: Float)
}


// MARK: - LTMorphingLabel
@IBDesignable public class LTMorphingLabel: UILabel {
    
    @IBInspectable public var morphingProgress: Float = 0.0
    @IBInspectable public var morphingDuration: Float = 0.6
    @IBInspectable public var morphingCharacterDelay: Float = 0.026
    @IBInspectable public var morphingEnabled: Bool = true

    @IBOutlet public weak var delegate: LTMorphingLabelDelegate?
    public var morphingEffect: LTMorphingEffect = .Scale
    
    var startClosures = [String: LTMorphingStartClosure]()
    var effectClosures = [String: LTMorphingEffectClosure]()
    var drawingClosures = [String: LTMorphingDrawingClosure]()
    var progressClosures = [String: LTMorphingManipulateProgressClosure]()
    var skipFramesClosures = [String: LTMorphingSkipFramesClosure]()
    var diffResults: LTStringDiffResult?
    var previousText = ""
    
    var currentFrame = 0
    var totalFrames = 0
    var totalDelayFrames = 0
    
    var totalWidth: Float = 0.0
    var previousRects = [CGRect]()
    var newRects = [CGRect]()
    var charHeight: CGFloat = 0.0
    var skipFramesCount: Int = 0
    
    #if TARGET_INTERFACE_BUILDER
    let presentingInIB = true
    #else
    let presentingInIB = false
    #endif
    
    override public var font: UIFont! {
        get {
            return super.font
        }
        set {
            super.font = newValue
            setNeedsLayout()
        }
    }
    
    override public var text: String! {
        get {
            return super.text
        }
        set {
            guard text != newValue else { return }

            previousText = text ?? ""
            diffResults = previousText.diffWith(anotherString: newValue)
            super.text = newValue ?? ""
            
            morphingProgress = 0.0
            currentFrame = 0
            totalFrames = 0
            
            setNeedsLayout()
            
            if !morphingEnabled {
                return
            }
            
            if presentingInIB {
                morphingDuration = 0.01
                morphingProgress = 0.5
            } else if previousText != text {
                displayLink.isPaused = false
                let closureKey = "\(morphingEffect.description)\(LTMorphingPhases.Start)"
                if let closure = startClosures[closureKey] {
                    return closure()
                }
                
                delegate?.morphingDidStart?(label: self)
            }
        }
    }
    
    public override func setNeedsLayout() {
        super.setNeedsLayout()
        previousRects = rectsOfEachCharacter(textToDraw: previousText, withFont: font)
        newRects = rectsOfEachCharacter(textToDraw: text ?? "", withFont: font)
    }
    
    override public var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            setNeedsLayout()
        }
    }
    
    override public var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            setNeedsLayout()
        }
    }
    
    internal lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(LTMorphingLabel.displayFrameTick))
        displayLink.add(
            to: RunLoop.current,
            forMode: RunLoopMode.commonModes)
        return displayLink
        }()
    
    lazy var emitterView: LTEmitterView = {
        let emitterView = LTEmitterView(frame: self.bounds)
        self.addSubview(emitterView)
        return emitterView
        }()
}

// MARK: - Animation extension
extension LTMorphingLabel {

    @objc func displayFrameTick() {
        if displayLink.duration > 0.0 && totalFrames == 0 {
            var frameRate = Float(0)
                if #available(iOS 10.0, *) {
                    var frameInterval = 1
                    if displayLink.preferredFramesPerSecond == 60 {
                            frameInterval = 1
                        } else if displayLink.preferredFramesPerSecond == 30 {
                            frameInterval = 2
                        } else {
                            frameInterval = 1
                        }
                    frameRate = Float(displayLink.duration) / Float(frameInterval)
                    } else {
                        frameRate = Float(displayLink.duration) / Float(displayLink.frameInterval)
                    }
            totalFrames = Int(ceil(morphingDuration / frameRate))

            let totalDelay = Float((text!).characters.count) * morphingCharacterDelay
            totalDelayFrames = Int(ceil(totalDelay / frameRate))
        }

        currentFrame += 1

        if previousText != text && currentFrame < totalFrames + totalDelayFrames + 5 {
            morphingProgress += 1.0 / Float(totalFrames)

            let closureKey = "\(morphingEffect.description)\(LTMorphingPhases.SkipFrames)"
            if let closure = skipFramesClosures[closureKey] {
                skipFramesCount += 1
                if skipFramesCount > closure() {
                    skipFramesCount = 0
                    setNeedsDisplay()
                }
            } else {
                setNeedsDisplay()
            }

            if let onProgress = delegate?.morphingOnProgress {
                onProgress(self, morphingProgress)
            }
        } else {
            displayLink.isPaused = true

            delegate?.morphingDidComplete?(label: self)
        }
    }
    
    // Could be enhanced by kerning text:
    // http://stackoverflow.com/questions/21443625/core-text-calculate-letter-frame-in-ios
    func rectsOfEachCharacter(textToDraw: String, withFont font: UIFont) -> [CGRect] {
        var charRects = [CGRect]()
        var leftOffset: CGFloat = 0.0
        
        charHeight = "Leg".size(withAttributes: [NSAttributedStringKey.font: font]).height
        
        let topOffset = (bounds.size.height - charHeight) / 2.0
        
        for (_, char) in textToDraw.characters.enumerated() {
            let charSize = String(char).size(withAttributes: [NSAttributedStringKey.font: font])
            charRects.append(
                CGRect(
                    origin: CGPoint(
                        x: leftOffset,
                        y: topOffset
                    ),
                    size: charSize
                )
            )
            leftOffset += charSize.width
        }
        
        totalWidth = Float(leftOffset)
        
        var stringLeftOffSet: CGFloat = 0.0
        
        switch textAlignment {
        case .center:
            stringLeftOffSet = CGFloat((Float(bounds.size.width) - totalWidth) / 2.0)
        case .right:
            stringLeftOffSet = CGFloat(Float(bounds.size.width) - totalWidth)
        default:
            ()
        }
        
        var offsetedCharRects = [CGRect]()
        
        for r in charRects {
            offsetedCharRects.append(r.offsetBy(dx: stringLeftOffSet, dy: 0.0))
        }
        
        return offsetedCharRects
    }
    
    func limboOfOriginalCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            var currentRect = previousRects[index]
            let oriX = Float(currentRect.origin.x)
            var newX = Float(currentRect.origin.x)
            let diffResult = diffResults!.0[index]
            var currentFontSize: CGFloat = font.pointSize
            var currentAlpha: CGFloat = 1.0
            
            switch diffResult {
                // Move the character that exists in the new text to current position
            case .Same:
                newX = Float(newRects[index].origin.x)
                currentRect.origin.x = CGFloat(
                    LTEasing.easeOutQuint(t: progress, oriX, newX - oriX)
                )
            case .Move(let offset):
                newX = Float(newRects[index + offset].origin.x)
                currentRect.origin.x = CGFloat(
                    LTEasing.easeOutQuint(t: progress, oriX, newX - oriX)
                )
            case .MoveAndAdd(let offset):
                newX = Float(newRects[index + offset].origin.x)
                currentRect.origin.x = CGFloat(
                    LTEasing.easeOutQuint(t: progress, oriX, newX - oriX)
                )
            default:
                // Otherwise, remove it
                
                // Override morphing effect with closure in extenstions
                if let closure = effectClosures[
                    "\(morphingEffect.description)\(LTMorphingPhases.Disappear)"
                    ] {
                        return closure(char, index, progress)
                } else {
                    // And scale it by default
                    let fontEase = CGFloat(
                        LTEasing.easeOutQuint(t:
                            progress, 0, Float(font.pointSize)
                        )
                    )
                    // For emojis
                    currentFontSize = max(0.0001, font.pointSize - fontEase)
                    currentAlpha = CGFloat(1.0 - progress)
                    currentRect = previousRects[index].offsetBy(
                        dx: 0,
                        dy: CGFloat(font.pointSize - currentFontSize)
                    )
                }
            }
            
            return LTCharacterLimbo(
                char: char,
                rect: currentRect,
                alpha: currentAlpha,
                size: currentFontSize,
                drawingProgress: 0.0
            )
    }
    
    func limboOfNewCharacter(
        char: Character,
        index: Int,
        progress: Float) -> LTCharacterLimbo {
            
            let currentRect = newRects[index]
            var currentFontSize = CGFloat(
                LTEasing.easeOutQuint(t: progress, 0, Float(font.pointSize))
            )
            
            if let closure = effectClosures[
                "\(morphingEffect.description)\(LTMorphingPhases.Appear)"
                ] {
                    return closure(char, index, progress)
            } else {
                currentFontSize = CGFloat(
                    LTEasing.easeOutQuint(t: progress, 0.0, Float(font.pointSize))
                )
                // For emojis
                currentFontSize = max(0.0001, currentFontSize)
                
                let yOffset = CGFloat(font.pointSize - currentFontSize)
                
                return LTCharacterLimbo(
                    char: char,
                    rect: currentRect.offsetBy(dx: 0, dy: yOffset),
                    alpha: CGFloat(morphingProgress),
                    size: currentFontSize,
                    drawingProgress: 0.0
                )
            }
    }
    
    func limboOfCharacters() -> [LTCharacterLimbo] {
        var limbo = [LTCharacterLimbo]()
        
        // Iterate original characters
        for (i, character) in previousText.characters.enumerated() {
            var progress: Float = 0.0
            
            if let closure = progressClosures[
                "\(morphingEffect.description)\(LTMorphingPhases.Progress)"
                ] {
                    progress = closure(i, morphingProgress, false)
            } else {
                progress = min(1.0, max(0.0, morphingProgress + morphingCharacterDelay * Float(i)))
            }
            
            let limboOfCharacter = limboOfOriginalCharacter(char: character, index: i, progress: progress)
            limbo.append(limboOfCharacter)
        }
        
        // Add new characters
        for (i, character) in (text!).characters.enumerated() {
            if i >= (diffResults?.0.count)! {
                break
            }
            
            var progress: Float = 0.0
            
            if let closure = progressClosures[
                "\(morphingEffect.description)\(LTMorphingPhases.Progress)"
                ] {
                    progress = closure(i, morphingProgress, true)
            } else {
                progress = min(1.0, max(0.0, morphingProgress - morphingCharacterDelay * Float(i)))
            }
            
            // Don't draw character that already exists
            if diffResults?.skipDrawingResults[i] == true {
                continue
            }
            
            if let diffResult = diffResults?.0[i] {
                switch diffResult {
                case .MoveAndAdd, .Replace, .Add, .Delete:
                    let limboOfCharacter = limboOfNewCharacter(
                        char: character,
                        index: i,
                        progress: progress
                    )
                    limbo.append(limboOfCharacter)
                default:
                    ()
                }
            }
        }
        
        return limbo
    }

}


// MARK: - Drawing extension
extension LTMorphingLabel {
    
    override public func didMoveToSuperview() {
        if let s = text {
            text = s
        }
        // Load all morphing effects
        for effectName: String in LTMorphingEffect.allValues {
            let effectFunc = Selector("\(effectName)Load")
            if LTMorphingLabel.responds(to: effectFunc) {
                LTMorphingLabel.performSelector(onMainThread: effectFunc, with: nil, waitUntilDone: true)
            }
        }
    }
    
    override public func drawText(in rect: CGRect) {
        if !morphingEnabled || limboOfCharacters().count == 0 {
            super.drawText(in: rect)
            return
        }
        
        for charLimbo in limboOfCharacters() {
            let charRect = charLimbo.rect
            
            let willAvoidDefaultDrawing: Bool = {
                if let closure = drawingClosures[
                    "\(morphingEffect.description)\(LTMorphingPhases.Draw)"
                    ] {
                        return closure($0)
                }
                return false
                }(charLimbo)
            
            if !willAvoidDefaultDrawing {
                let s = String(charLimbo.char)
                s.draw(in: charRect, withAttributes: [
                    NSAttributedStringKey.font:
                        UIFont.init(name: font.fontName, size: charLimbo.size)!,
                    NSAttributedStringKey.foregroundColor:
                        textColor.withAlphaComponent(charLimbo.alpha)
                    ])
            }
        }
    }

}
