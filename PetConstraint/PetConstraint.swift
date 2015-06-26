//
//  PetConstraint.swift
//  PetConstraint
//
//  Created by 程巍巍 on 6/26/15.
//  Copyright © 2015 Littocats. All rights reserved.
//

import Foundation
import UIKit

struct PetConstraint {
    // Format
    private var format: String
    private var options = NSLayoutFormatOptions(rawValue: 0)
    private var metrics: [String : AnyObject]!
    
    init(format: String) {self.format = format}
    
    mutating func options(options: NSLayoutFormatOptions)->PetConstraint   {self.options = options; return self}
    mutating func metrics(metrics: [String: AnyObject]?)->PetConstraint    {self.metrics = metrics; return self}
    
    func views(views: [String: UIView]) ->Constraints {return Constraints(format: self, views: views)}
    
    struct Constraints {
        var format: PetConstraint
        var views: [String: UIView]
        
        func addTo(view: UIView) {
            
            for (_, v) in views {
                if v.isDescendantOfView(view) {
                    v.translatesAutoresizingMaskIntoConstraints = false
                }
            }
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format.format, options: format.options, metrics: format.metrics, views: views))
        }
    }

    init(_ format: String) {
        self.format = format
    }
    
    // 重载运算符所需
    struct Alias {
        private var view: UIView
        private var attribute: NSLayoutAttribute
        private var constant: CGFloat = 0
        private var multiplier: CGFloat = 1
        
        private init(view: UIView, attribute: NSLayoutAttribute){
            self.view = view
            self.attribute = attribute
        }
        
        private func use(relation: NSLayoutRelation, constant: CGFloat)->NSLayoutConstraint {
            let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
            view.addConstraint(constraint)
            return constraint
        }
        
        struct Constraint {
            private var fa: Alias
            private var sa: Alias
            private var re: NSLayoutRelation
            
            private func use()->NSLayoutConstraint {
                let constraint = NSLayoutConstraint(item: fa.view, attribute: fa.attribute, relatedBy: re, toItem: sa.view, attribute: sa.attribute, multiplier: sa.multiplier/fa.multiplier, constant: sa.constant-fa.constant)
                // 找到 fa sa 的共有 super view
                var manager: UIView!
                if fa.view.isDescendantOfView(sa.view) {
                    manager = sa.view
                }else if sa.view.isDescendantOfView(fa.view){
                    manager = fa.view
                }else{
                    if var suv: UIView! = fa.view.superview {
                        while suv != nil {
                            if sa.view.isDescendantOfView(suv!) {
                                manager = suv
                                break
                            }
                            suv = suv?.superview
                        }
                    }
                    if manager == nil{
                        print("找不到能管理该约束的 view , 两个 view 不相同且没有公共的 superview")
                        abort()
                    }
                }
                fa.view.translatesAutoresizingMaskIntoConstraints = false
                manager.addConstraint(constraint)
                return constraint
            }
            
        }
    }
}

func *(var lv: PetConstraint.Alias, multiplier: CGFloat)->PetConstraint.Alias {
    lv.multiplier *= multiplier
    return lv
}
func /(var lv: PetConstraint.Alias, multiplier: CGFloat)->PetConstraint.Alias {
    lv.multiplier /= multiplier
    return lv
}
func +(var lv: PetConstraint.Alias, constant: CGFloat)->PetConstraint.Alias {
    lv.constant = constant
    return lv
}
func -(var lv: PetConstraint.Alias, constant: CGFloat)->PetConstraint.Alias {
    lv.constant = -constant
    return lv
}

func ==(lv: PetConstraint.Alias, rv: PetConstraint.Alias) ->NSLayoutConstraint {
    return PetConstraint.Alias.Constraint(fa: lv, sa: rv, re: .Equal).use()
}
func >=(lv: PetConstraint.Alias, rv: PetConstraint.Alias) ->NSLayoutConstraint {
    return PetConstraint.Alias.Constraint(fa: lv, sa: rv, re: .GreaterThanOrEqual).use()
}
func <=(lv: PetConstraint.Alias, rv: PetConstraint.Alias) ->NSLayoutConstraint {
    return PetConstraint.Alias.Constraint(fa: lv, sa: rv, re: .LessThanOrEqual).use()
}

func ==(lv: PetConstraint.Alias, constant: CGFloat)->NSLayoutConstraint {
    return lv.use(.Equal, constant: constant)
}
func >=(lv: PetConstraint.Alias, constant: CGFloat)->NSLayoutConstraint {
    return lv.use(.Equal, constant: constant)
}
func <=(lv: PetConstraint.Alias, constant: CGFloat)->NSLayoutConstraint {
    return lv.use(.Equal, constant: constant)
}

extension UIView {
    var Left:       PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Left)}
    var Right:      PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Right)}
    var Top:        PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Top)}
    var Bottom:     PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Bottom)}
    var Leading:    PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Leading)}
    var Trailing:   PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Trailing)}
    var Width:      PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Width)}
    var Height:     PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .Height)}
    var CenterX:    PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .CenterX)}
    var CenterY:    PetConstraint.Alias {return PetConstraint.Alias(view: self, attribute: .CenterY)}
}