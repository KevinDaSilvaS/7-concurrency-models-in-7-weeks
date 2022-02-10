(defn reduce-sum [numbers]
  #_=> (reduce #(+ %1 %2) 0 numbers))


(defn recursive-sum [numbers]
    (loop [sum 0 nums numbers] 
    (if (empty? nums) 
    sum
    (recur (+ sum (first nums)) (rest nums)))))

    ;(loop [sum 0
       ;cnt 10]
    ;(if (= cnt 0)
      ;sum
    ;(recur (+ cnt sum) (dec cnt))))