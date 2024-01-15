;; Generic Search Algorithm

(defun commun-algorithm (ft-fix-open-list ft-init-open-list &optional heuristic)
  "Common algorithm between BFS, DFS and A*"
  (let ((counter-nodes-closed 0)
	(list-open-nodes (funcall ft-init-open-list)))
    (let ((is-solution (validate-childs list-open-nodes)))
      (if (not (null is-solution)) (return-from commun-algorithm is-solution)))
    (labels
	((recursive-algorithm ()
	   (incf counter-nodes-closed)
	   (let* ((node (pop list-open-nodes))
		  (childs (partenogenese node heuristic)))
	     (let ((is-solution (validate-childs childs)))
	       (if (not (null is-solution)) (return-from recursive-algorithm is-solution)))
	     (setf list-open-nodes (funcall ft-fix-open-list list-open-nodes childs)))
	     (if (not (null list-open-nodes)) (recursive-algorithm))))
      (if (not (null list-open-nodes)) 
	  (let ((result (recursive-algorithm)))
	    (print (penetrance
	     (get-node-depth result)
	     (+ 1 counter-nodes-closed (length list-open-nodes))))
	    result)))))


;; ### BFS #################################################################################

(defun breadth-first-search ()
  "Performs Breadth-First Search on a graph starting from the given node."
  (commun-algorithm #'(lambda (list-open-nodes childs)
	    (append list-open-nodes childs))
	#'init-open-list))


;; ### DFS #################################################################################

(defun depth-first-search ()
   "Performs Depth-First Search on a graph."
  (commun-algorithm #'
   (lambda (list-open-nodes childs)
     (append childs list-open-nodes))
   #'init-open-list))


;; ### A* ##################################################################################

(defun a* (heuristic)
  "Performs A* on a graph."
  (commun-algorithm
   #'(lambda (list-open-nodes childs)
       (sort-open-list-ascending (append list-open-nodes childs)))
   #'(lambda ()
       (sort-open-list-ascending (init-open-list heuristic)))
   heuristic))

;; ### IDA* ################################################################################

(defun ida* (heuristic)
  "Performs IDA on a graph"
  (let*
      ((counter-nodes-closed 0)
       (list-open-nodes (sort-open-list-ascending (init-open-list heuristic)))
       (max-cost (apply #'min (mapcar #'first (mapcar #'get-node-fgh list-open-nodes))))
       (c 0))
    (let ((is-solution (validate-childs list-open-nodes)))
      (if is-solution (return-from ida* is-solution)))
    (labels
	((algorithm ()
	   (incf counter-nodes-closed)
	   (cond
	     ((null list-open-nodes) nil)
	     ((<= (first (get-node-fgh (first list-open-nodes))) max-cost)
	      (let* ((node (pop list-open-nodes))
		     (childs (partenogenese node heuristic)))
		(let ((is-solution (validate-childs childs)))
		  (if is-solution (return-from algorithm is-solution)))
		(setf list-open-nodes
		      (sort-open-list-ascending (append list-open-nodes childs))))
		    (if (not (null list-open-nodes)) (algorithm)))
	     (t
              (incf c)
              (print c)
	      (setf max-cost (first (get-node-fgh (first list-open-nodes))))
	      (setf counter-nodes-closed 0)
	      (setf list-open-nodes
		    (sort-open-list-ascending (init-open-list heuristic)))
	      (algorithm)))))
      (if (not (null list-open-nodes)) 
	  (let ((result (algorithm)))
	    (penetrance
	     (get-node-depth result)
	     (+ counter-nodes-closed (length list-open-nodes)))
	    result)))))
	     
;; ### SMA* ################################################################################


(defun sma* (heuristic &optional (limit 10))
  "Performs A* on a graph."
  (commun-algorithm
   #'(lambda (list-open-nodes childs)
       (let ((temp (append list-open-nodes childs)))
	 (subseq (sort-open-list-ascending temp) 0
		 (min (length temp) limit))))
   #'(lambda ()
       (let ((temp (init-open-list heuristic)))
	 (subseq (sort-open-list-ascending temp) 0
		 (min (length temp) limit))))
   heuristic))


;; ### RBFS ################################################################################

(defun element-in-list-p (element list)
  "Check if the list contains the given element using member."
  (member element list :test #'equal))

(defun update-parent (node children)
  "Update the parent node scores based on the scores of the children nodes."
  (cond ((null (get-node-parent node)) nil)
        (t 
         (setf (first (get-node-fgh (get-node-parent node)))
               (apply #'min (mapcar #'(lambda (value) (first (get-node-fgh value))) children))))))


(defun rbfs(list-open-nodes node heuristic)
  (print-current-state node)
  "Recursive Best-First Search algorithm."
  (cond ((>= (get-node-score node) score) node)
        ((and (null list-open-nodes) (null node)) nil)
        (t (let* ((children (partenogenese node heuristic))
                  (new-lst-open (sort-open-list-ascending (append (rest list-open-nodes) children)))
                  (next-node (first new-lst-open)))
             (print list-open-nodes)
             (print children)
           (cond ((and next-node (element-in-list-p next-node children))
                  (let ((solution (rbfs new-lst-open next-node heuristic)))
                    (cond ((>= (get-node-score solution) score) solution)
                          (t (update-parent node children)))))
                 (t (update-parent node children)))))))
                  
